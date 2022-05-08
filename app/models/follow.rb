class Follow < ApplicationRecord
  belongs_to :following, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :following_id }
  validate :self_follow_action

  def self_follow_action
    errors.add(:base, 'users cannot follow themselves') if following == follower
  end
end
