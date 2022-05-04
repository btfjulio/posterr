module Api
  module V1
    module Users
      class ProfilesController < ApplicationController
        def show
          return render_user_not_found if profile_user.blank?

          render json: profile_user, params: params, serializer: UserProfileSerializer
        end

        private

        def profile_user
          User.find_by(id: params[:user_id])
        end

        def render_user_not_found
          render json: { message: ['Profile user not found'] }, status: :not_found
        end
      end
    end
  end
end
