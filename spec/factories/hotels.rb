FactoryBot.define do
  factory :hotel do
    Hotel_name { Faker::Company.name }
    association :user
  end
end