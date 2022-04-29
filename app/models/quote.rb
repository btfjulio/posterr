class Quote < ApplicationRecord
  include Entryable
  include Contentable

  belongs_to :post, optional: false
end
