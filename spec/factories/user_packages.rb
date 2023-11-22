FactoryBot.define do
  factory :user_package do
    association :user
    association :currency_package
  end
end
