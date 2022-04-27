FactoryBot.define do
  factory :post do
    content { Faker::Lorem.sentence(word_count: 3) }

    trait :with_user do
      transient do
        user { nil }
      end

      after(:create) do |post, evaluator|
        create :entry, entryable: post, user: evaluator.user, created_at: post.created_at
      end
    end
  end
end
