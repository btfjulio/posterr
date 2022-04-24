class User < ApplicationRecord
  ALPHANUMERIC_PATTERN = /\A[A-Za-z0-9]+\z/.freeze
  NAME_LENGTH_LIMIT = 14

  validates :name,
            presence: true,
            format:   { with: ALPHANUMERIC_PATTERN, message: 'only allows alphanumeric characters' },
            length:   { maximum: NAME_LENGTH_LIMIT }
end
