require 'swagger_helper'

RSpec.describe 'Quote', swagger_doc: 'v1/swagger.yaml', bullet: true do
  path '/api/v1/entries/quotes' do
    post 'Create user Quote' do
      tags 'Quote'
      consumes 'application/json'
      produces 'application/json'
      description <<-PARAMS
        Example of Request

        http://localhost:3000/api/v1/entries/quotes?current_user_id=1

        {
          "params": {
            "user_id": 1,
            "quote": {
              "post_id": '1',
              "content": 'Lorem Ipsum'
            }
          }
        }
      PARAMS

      parameter name: :current_user_id, in: :query
      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          user_id: { type: :integer, description: 'User ID', required: true },
          quote:   {
            type:       :object,
            properties: {
              post_id: { type: :integer, description: 'ID from quoted Post', required: true },
              content: { type: :string, required: true }
            }
          }
        }
      }

      let(:current_user) { create :user }
      let(:current_user_id) { current_user.id }

      response '201', 'creates new quote' do
        let(:quoted_post) { create :post }

        let(:params) do
          {
            user_id: current_user.id,
            quote:   {
              post_id: quoted_post.id,
              content: 'Lorem Ipsum'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)

          data = JSON.parse(response.body)
          expect(data['post_id']).to eq quoted_post.id
          expect(data['content']).to eq 'Lorem Ipsum'
        end
      end

      response '422', 'when quote is not valid' do
        let(:params) do
          {
            user_id: current_user.id,
            quote:   {
              post_id: 'Z',
              content: 'Lorem Ipusum'
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
