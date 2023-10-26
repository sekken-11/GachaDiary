FactoryBot.define do
  factory :currency_package do
    sequence(:name) { |n| "game-#{n}" }
    need_one_gacha_stones { Faker::Number.between(from: 150, to: 300) }
    price { Faker::Number.between(from: 100, to: 200) }
    quantity { Faker::Number.between(from: 100, to: 200) }
    association :user
  end
end
