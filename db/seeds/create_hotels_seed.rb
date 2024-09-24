module Seeds
  class CreateHotelsSeed
    def self.seed_hotels
      puts "seeding Hotels"
      User.hotel_owner.each do |owner|
         3.times do 
            Hotel.create!(
               Hotel_name: Faker::Restaurant.name,
               user: owner
            )
         end
      end
      puts "Created #{Hotel.count} hotels"
    end
  end
end