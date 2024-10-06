FactoryBot.define do
  factory :orderItem do
    price { Faker::Commerce.price(range: 10..500) }
    quantity { Faker::Number.between(from: 1, to: 10) }
    association :order
    association :menu
  end
end