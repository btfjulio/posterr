FactoryBot.define do
  factory :repost do
    post

    trait :with_user do
      transient do
        user { nil }
      end

      after(:create) do |repost, evaluator|
        create :entry, entryable: repost, user: evaluator.user, created_at: repost.created_at
      end
    end
  end
end
