require 'swagger_helper'

RSpec.describe 'Post', swagger_doc: 'v1/swagger.yaml', bullet: true do
  path '/api/v1/entries/posts' do
    post 'Create user Post' do
      tags 'Post'
      consumes 'application/json'
      produces 'application/json'
      description <<-PARAMS
        Example of Request

        http://localhost:3000/api/v1/entries/posts?current_user_id=1

        {
          "params": {
            "user_id": 1,
            "post": { "content": 'Lorem Ipsum' }
          }
        }
      PARAMS

      parameter name: :current_user_id, in: :query
      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          user_id: { type: :integer, description: 'User ID', required: true },
          post:    {
            type:       :object,
            properties: {
              content: { type: :string, required: true }
            }
          }
        }
      }

      let(:current_user) { create :user }
      let(:current_user_id) { current_user.id }

      response '201', 'creates new post' do
        let(:params) do
          {
            user_id: current_user.id,
            post:    {
              content: 'Lorem Ipsum'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)

          data = JSON.parse(response.body)
          expect(data['content']).to eq 'Lorem Ipsum'
        end
      end

      response '422', 'when post is not valid' do
        let(:params) do
          {
            user_id: current_user.id,
            post:    {
              content: ''
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)

          data = JSON.parse(response.body)
          expect(data['message']['content'].first).to eq "can't be blank"
        end
      end

      response '422', ' when entry is not valid' do
        let(:params) do
          {
            user_id: current_user.id,
            post:    {
              content: 'Lorem Ipsum'
            }
          }
        end

        before { create_list(:post, 5, :with_user, user: current_user, created_at: Time.zone.today) }

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)

          data = JSON.parse(response.body)
          expect(data['message']['base'].first).to eq 'A user is not allowed to post more than 5 posts in one day'
        end
      end
    end
  end
end
