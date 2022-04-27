class Entry < ApplicationRecord
  DAILY_LIMIT = 5

  belongs_to :user, optional: false

  delegated_type :entryable, types: Entryable::TYPES, validate: true

  validates :user, presence: true
  validate :user_daily_limit, on: :create

  scope :created_today, -> { where(created_at: Time.zone.today..) }
  scope :from_user, -> (user) { where(user: user) }
  scope :with_entryables, -> { includes(:entryable) }

  def user_daily_limit
    return if user.entries.created_today.count < DAILY_LIMIT

    errors.add(:base, 'A user is not allowed to post more than 5 posts in one day')
  end
end
