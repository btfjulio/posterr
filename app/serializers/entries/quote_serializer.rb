module Entries
  class QuoteSerializer < ActiveModel::Serializer
    attributes :content, :post_content, :post_id

    alias quote object
    delegate :content, :post_id, to: :quote

    def post_content
      quote.post.content
    end
  end
end
