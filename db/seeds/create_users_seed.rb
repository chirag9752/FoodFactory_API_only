module Seeds
  class CreateUsersSeed
    def self.seed_users
      puts "seeding users"
    
      admin = User.create!(
        name: "Admin",
        email: "admin@example.com",
        password: "password",
        password_confirmation: "password",
        role: :admin
      )
    
      hotel_owner = User.create!(
        name: "Hotel owner",
        email: "hotelowner@example.com",
        password: "password",
        password_confirmation: "password",
        role: :hotel_owner
      )
    
      10.times do |i|
        User.create!(
          name: Faker::Name.name,
          email: Faker::Internet.email,
          password: "password",
          password_confirmation: "password",
          role: :client
        )
      end
    
      puts "Created #{User.count} users"
    end
  end
end