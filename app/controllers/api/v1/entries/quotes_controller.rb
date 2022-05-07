module Api
  module V1
    module Entries
      class QuotesController < BaseController
        ENTRYABLE = Quote

        def permitted_params
          params.require(:quote).permit(:post_id, :content)
        end
      end
    end
  end
end
