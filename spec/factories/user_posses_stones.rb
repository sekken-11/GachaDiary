FactoryBot.define do
  factory :user_posses_stone do
    quantity { Faker::Number.between(from: 5000, to: 30000) }
    association :user
    association :currency_package
  end
end
