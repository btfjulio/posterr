require 'swagger_helper'

RSpec.describe 'Follow', swagger_doc: 'v1/swagger.yaml', bullet: true do
  path '/api/v1/follows' do
    post 'Create user Follow' do
      tags 'Follow'
      consumes 'application/json'
      produces 'application/json'
      description <<-PARAMS
        Example of Request

        http://localhost:3000/api/v1/follows?current_user_id=1

        {
          "params": {
            "user_id": 1,
            "following_id": 2
          }
        }
      PARAMS

      parameter name: :current_user_id, in: :query
      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          user_id: { type: :integer, description: 'Followed User ID', required: true }
        }
      }

      let(:current_user) { create :user }
      let(:current_user_id) { current_user.id }
      let(:following_user) { create :user }

      response '201', 'creates new follow relationship' do
        let(:params) do
          { user_id: following_user.id }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)

          expect(current_user.followings).to include following_user
          expect(following_user.followers).to include current_user
        end
      end

      response '422', 'invalid follow' do
        let(:params) do
          { user_id: current_user.id }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)

          data = JSON.parse(response.body)
          expect(data['message']['base'].first).to eq 'users cannot follow themselves'
        end
      end
    end
  end
end
