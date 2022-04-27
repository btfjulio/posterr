module Contentable
  extend ActiveSupport::Concern

  CONTENT_LENGTH_LIMIT = 777

  included do
    validates :content, presence: true, length: { maximum: CONTENT_LENGTH_LIMIT }
  end
end
