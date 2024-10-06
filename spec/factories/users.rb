FactoryBot.define do
  factory :user do 
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    role { "hotel_owner" }
    password { "password" }
    password_confirmation { "password" }
    
    trait :admin do
      role { "admin" }
    end

    trait :client do
      role { "client" }
    end
  end
end