FactoryBot.define do
  factory :gacha do
    date { Faker::Date.between(from: 1.week.ago, to: 1.week.from_now) }
    count { Faker::Number.between(from: 10, to: 100) }
    description { Faker::Games::Pokemon.name }
    association :user
    association :currency_package
  end
end
