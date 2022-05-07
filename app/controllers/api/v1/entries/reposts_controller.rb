module Api
  module V1
    module Entries
      class RepostsController < BaseController
        ENTRYABLE = Repost

        def permitted_params
          params.require(:repost).permit(:post_id)
        end
      end
    end
  end
end
