FactoryBot.define do
  factory :order do
    total_price { Faker::Commerce.price(range: 50..500) }
    status { %w[pending completed cancelled].sample }  
    association :user
    association :hotel
  end
end