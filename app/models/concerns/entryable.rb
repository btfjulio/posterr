module Entryable
  extend ActiveSupport::Concern

  TYPES = %w[Post Repost Quote].freeze

  included do
    has_one :entry, as: :entryable, touch: true, dependent: :destroy
  end
end
