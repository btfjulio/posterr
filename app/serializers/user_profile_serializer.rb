class UserProfileSerializer < ActiveModel::Serializer
  attributes :name, :date_joined, :posts_count, :entries

  alias profile_user object
  delegate :name, to: :object

  def date_joined
    profile_user.created_at.strftime('%B %d, %Y')
  end

  def posts_count
    profile_user.entries.count
  end

  def entries
    ActiveModelSerializers::SerializableResource.new(profile_entries, each_serializer: EntrySerializer)
  end

  def profile_entries
    Users::ProfileEntries.call(profile_user, instance_options[:params])
  end
end
