require 'swagger_helper'

RSpec.describe 'Feed', swagger_doc: 'v1/swagger.yaml', bullet: true do
  path '/api/v1/feed' do
    get 'Lists user Home Page entries' do
      tags 'User Home Page Feed'
      produces 'application/json'
      parameter name: :current_user_id, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :only_following, in: :query, type: :boolean, required: false

      description <<-PARAMS
        Example of Request

        http://localhost:3000/api/v1/user/feed?current_user_id=1&page=1
        http://localhost:3000/api/v1/user/feed?current_user_id=1&page=1&only_following=true
      PARAMS

      let(:current_user) { create :user }
      let(:current_user_id) { current_user.id }

      let(:page) { 1 }
      let(:only_following) { false }

      response '200', 'user feed found' do
        schema type:       :object,
               properties: {
                 entries: {
                   type:  :array,
                   items: {
                     type: :object, properties: {
                       id:         { type: :integer, description: 'Entry ID' },
                       created_at: { type: :string },
                       user_id:    { type: :integer },
                       entry_type: { type: :string, description: 'Type of entry Post/Repost/Quote' },
                       entry_info: { type: :object, description: 'Info from entry object' }
                     }
                   }
                 }
               }
        let(:posts) do
          (1..10).map { |day| create :post, :with_user, user: current_user, created_at: Date.parse("#{day}/01/2022") }
        end
        let(:repost) do
          create :repost, :with_user, user: current_user, post: posts.sample, created_at: Date.parse('11/01/2022')
        end
        let(:quote) do
          create :quote, :with_user, user: current_user, post: posts.sample, created_at: Date.parse('12/01/2022')
        end

        before do
          posts
          repost
          quote
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          feed_entries = data['entries']
          expect(feed_entries.size).to eq 10
          expect(feed_entries.pluck('entry_type')).to eq %w[Quote Repost Post Post Post Post Post Post Post Post]
          expect(feed_entries.pluck('created_at'))
            .to eq ['January 12, 2022', 'January 11, 2022', 'January 10, 2022', 'January 09, 2022', 'January 08, 2022',
                    'January 07, 2022', 'January 06, 2022', 'January 05, 2022', 'January 04, 2022', 'January 03, 2022']
        end
      end

      context 'when only_following is true' do
        let(:only_following) { true }

        response '200', 'lists exclusively followings entries' do
          let(:posts_following) { create_list :post, 5, :with_user, user: first_user }
          let(:posts_not_following) { create_list :post, 5, :with_user, user: second_user }

          let(:first_user) { create :user }
          let(:second_user) { create :user }

          before do
            current_user.follow(first_user)
            posts_following
            posts_not_following
          end

          run_test! do |response|
            data = JSON.parse(response.body)

            feed_content = data['entries'].map { |entry| entry['entry_info']['content'] }
            expect(feed_content).to match_array posts_following.pluck(:content)
          end
        end
      end
    end
  end
end
