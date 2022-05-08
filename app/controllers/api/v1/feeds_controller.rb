module Api
  module V1
    class FeedsController < ApplicationController
      def index
        render json: current_user, serializer: UserFeedSerializer, params: params
      end
    end
  end
end
