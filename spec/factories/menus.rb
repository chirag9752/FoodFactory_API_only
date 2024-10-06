FactoryBot.define do
  factory :menu do
    menu_name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Commerce.price(range: 50..500) }
    association :hotel
  end
end