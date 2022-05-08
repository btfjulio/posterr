class UserProfileSerializer < ActiveModel::Serializer
  attributes :name, :date_joined, :posts_count, :entries, :followers_count, :followings_count, :follow_id

  alias profile_user object
  delegate :name, to: :object

  def date_joined
    profile_user.created_at.strftime('%B %d, %Y')
  end

  def posts_count
    profile_user.entries.count
  end

  def followers_count
    profile_user.followers.count
  end

  def followings_count
    profile_user.followings.count
  end

  def follow_id
    Follow.where(follower: current_user, following: profile_user).take&.id
  end

  def entries
    ActiveModelSerializers::SerializableResource.new(profile_entries, each_serializer: EntrySerializer)
  end

  def profile_entries
    Users::ProfileEntries.call(profile_user, instance_options[:params])
  end
end
