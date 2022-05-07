module Api
  module V1
    module Entries
      class PostsController < BaseController
        ENTRYABLE = Post

        def permitted_params
          params.require(:post).permit(:content)
        end
      end
    end
  end
end
