module Seeds
class CreateMenusSeed
    def self.seed_menus
    puts "Seeding Menus..."
  
    Hotel.all.each do |hotel|
      5.times do
        Menu.create!(
          menu_name: Faker::Food.dish,
          description: Faker::Food.description,
          price: rand(100..300),
          hotel: hotel
        )
      end
    end
  
    puts "Created #{Menu.count} menus"
  end
end
end