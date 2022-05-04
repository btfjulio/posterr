module Entries
  class PostSerializer < ActiveModel::Serializer
    attributes :content

    alias post object
    delegate :content, to: :post
  end
end
