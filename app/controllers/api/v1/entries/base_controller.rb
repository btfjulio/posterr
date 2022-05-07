module Api
  module V1
    module Entries
      class BaseController < ApplicationController
        def create
          if entry.save
            render json: entry.entryable, status: :created
          else
            render json: { message: entry_errors }, status: :unprocessable_entity
          end
        end

        private

        def entry
          # binding.pry
          @entry ||= Entry.new(user: current_user, entryable: entryable_params)
        end

        def entryable_params
          self.class::ENTRYABLE.new(permitted_params)
        end

        def entry_errors
          return entry.entryable.errors if entry.errors.key?(:entryable)

          entry.errors
        end
      end
    end
  end
end
