module Followable
  extend ActiveSupport::Concern

  included do
    has_many :follower_relationships,
             class_name:  'Follow',
             foreign_key: :follower_id,
             dependent:   :destroy,
             inverse_of:  :follower
    has_many :following_relationships,
             class_name:  'Follow',
             foreign_key: :following_id,
             dependent:   :destroy,
             inverse_of:  :following
    has_many :followers, through: :following_relationships, source: :follower
    has_many :followings, through: :follower_relationships, source: :following

    def follow(user)
      follower_relationships.create(following: user)
    end

    def unfollow(user)
      follower_relationships.find_by(following: user).destroy
    end
  end
end
