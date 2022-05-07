require 'swagger_helper'

RSpec.describe 'Repost', swagger_doc: 'v1/swagger.yaml', bullet: true do
  path '/api/v1/entries/reposts' do
    post 'Create user Repost' do
      tags 'Repost'
      consumes 'application/json'
      produces 'application/json'
      description <<-PARAMS
      Example of Request

        http://localhost:3000/api/v1/entries/reposts?current_user_id=1

        {
          "params": {
            "user_id": 1,
            "repost": { "post_id": '1' }
          }
        }
      PARAMS

      parameter name: :current_user_id, in: :query
      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          user_id: { type: :integer, description: 'User ID', required: true },
          repost:  {
            type:       :object,
            properties: {
              post_id: { type: :integer, description: 'ID from reposted Post', required: true }
            }
          }
        }
      }

      let(:current_user) { create :user }
      let(:current_user_id) { current_user.id }

      response '201', 'creates new repost' do
        let(:resposted_post) { create :post }

        let(:params) do
          {
            user_id: current_user.id,
            repost:  {
              post_id: resposted_post.id
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)

          data = JSON.parse(response.body)
          expect(data['post_id']).to eq resposted_post.id
        end
      end

      response '422', 'when repost is not valid' do
        let(:params) do
          {
            user_id: current_user.id,
            repost:  {
              post_id: 'Z'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)

          data = JSON.parse(response.body)
          expect(data['message']['post'].first).to eq 'must exist'
        end
      end
    end
  end
end
