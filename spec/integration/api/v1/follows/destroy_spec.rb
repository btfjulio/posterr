require 'swagger_helper'

RSpec.describe 'Unfollow', swagger_doc: 'v1/swagger.yaml', bullet: true do
  path '/api/v1/follows/{id}' do
    delete 'Destroy user Follow' do
      tags 'Unfollow'
      consumes 'application/json'
      produces 'application/json'
      description <<-PARAMS
        Example of Request

        http://localhost:3000/api/v1/follows/1?current_user_id=1

        {
          "params": {
            "user_id": 1
          }
        }
      PARAMS

      parameter name: :current_user_id, in: :query
      parameter name: :id, in: :path, type: :integer

      let(:current_user) { create :user }
      let(:current_user_id) { current_user.id }
      let(:following_user) { create(:user) }
      let(:follow) { create :follow, follower: current_user, following: following_user }

      response '204', 'destroyes follow relationship' do
        let(:id) { follow.id }

        before { follow }

        run_test! do |response|
          expect(response).to have_http_status(:success)

          expect(current_user.followings).not_to include following_user
          expect(following_user.followers).not_to include current_user
        end
      end
    end
  end
end
