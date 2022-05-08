class UserFeedSerializer < ActiveModel::Serializer
  attributes :entries

  alias user object
  delegate :name, to: :object

  def entries
    ActiveModelSerializers::SerializableResource.new(feed_entries, each_serializer: EntrySerializer)
  end

  def feed_entries
    Users::FeedEntries.call(user, instance_options[:params])
  end
end
