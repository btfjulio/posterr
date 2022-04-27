class Repost < ApplicationRecord
  include Entryable

  belongs_to :post, optional: false
end
