module Entries
  class RepostSerializer < ActiveModel::Serializer
    attributes :post_content, :post_id

    alias repost object
    delegate :post_id, to: :repost

    def post_content
      repost.post.content
    end
  end
end
