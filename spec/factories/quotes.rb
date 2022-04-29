FactoryBot.define do
  factory :quote do
    content { Faker::Lorem.sentence(word_count: 3) }
    post

    trait :with_user do
      transient do
        user { nil }
      end

      after(:create) do |quote, evaluator|
        create :entry, entryable: quote, user: evaluator.user, created_at: quote.created_at
      end
    end
  end
end
