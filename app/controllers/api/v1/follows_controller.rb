module Api
  module V1
    class FollowsController < ApplicationController
      def create
        follow = current_user.follow(following_user)
        if follow.valid?
          render json: follow, status: :created
        else
          render json: { message: follow.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        current_user.follower_relationships.find(params[:id]).destroy
        head :no_content
      end

      private

      def following_user
        User.find(params[:user_id])
      end
    end
  end
end
