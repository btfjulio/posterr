require 'swagger_helper'

RSpec.describe 'User', swagger_doc: 'v1/swagger.yaml', bullet: true do
  path '/api/v1/users/{user_id}/profile' do
    get 'Retrieve User Profile Info' do
      tags 'User Profile'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string
      parameter name: :current_user_id, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer

      description <<-PARAMS
        Example of Request

        http://localhost:3000/api/v1/user/1/profile?current_user_id=1
        http://localhost:3000/api/v1/user/1/profile?current_user_id=1&page=1
      PARAMS

      let(:current_user) { create :user }
      let(:current_user_id) { current_user.id }

      response '200', 'user profile found' do
        schema type:       :object,
               properties: {
                 username:         { type: :string },
                 date_joined:      { type: :string },
                 posts_count:      { type: :integer },
                 followings_count: { type: :integer, description: 'Number of users following the profile owner' },
                 followers_count:  { type: :integer, description: 'Number of users follower by the profile owner' },
                 follow_id:        {
                   type:         :integer,
                   'x-nullable': true,
                   description:  'Follow relationship ID if it exists'
                 },
                 entries:          {
                   type:  :array,
                   items: {
                     type: :object, properties: {
                       id:         { type: :integer },
                       user_id:    { type: :integer },
                       created_at: { type: :string },
                       entry_type: { type: :string, description: 'Type of entry Post/Repost/Quote' },
                       entry_info: { type: :object, description: 'Info from entry object' }
                     }
                   }
                 }
               }

        let(:profile_user) { create :user, created_at: Date.parse('01/01/2022') }
        let(:user_id) { profile_user.id }
        let(:page) { 1 }

        let(:post) { create :post, :with_user, user: profile_user, created_at: Date.parse('01/01/2022') }
        let(:repost) do
          create :repost, :with_user, user: profile_user, post: post, created_at: Date.parse('02/01/2022')
        end
        let(:quote) { create :quote, :with_user, user: profile_user, post: post, created_at: Date.parse('03/01/2022') }
        let(:follow) { create :follow, following: profile_user, follower: current_user }

        before do
          follow
          post
          repost
          quote
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['name']).to eq profile_user.name
          expect(data['date_joined']).to eq 'January 01, 2022'
          expect(data['posts_count']).to eq 3
          expect(data['followings_count']).to eq 0
          expect(data['followers_count']).to eq 1
          expect(data['follow_id']).to be follow.id

          profile_entries = data['entries']
          expect(profile_entries.size).to eq 3
          expect(profile_entries.pluck('entry_type')).to eq %w[Quote Repost Post]
          expect(profile_entries.pluck('created_at')).to eq ['January 03, 2022', 'January 02, 2022', 'January 01, 2022']
        end
      end

      response '404', 'user profile not found' do
        let(:user_id) { 3 }
        let(:page) { 1 }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)

          data = JSON.parse(response.body)
          expect(data['message'].first).to eq 'Profile user not found'
        end
      end
    end
  end
end
