class Post < ApplicationRecord
  include Entryable
  include Contentable

  has_many :reposts, dependent: :nullify
end
