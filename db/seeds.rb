# User.destroy_all
# Hotel.destroy_all
# Menu.destroy_all
# Order.destroy_all

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end

class SeedDb
  def self.call_for_create
    Seeds::CreateUsersSeed.seed_users
    Seeds::CreateHotelsSeed.seed_hotels
    Seeds::CreateMenusSeed.seed_menus
    Seeds::CreateOrdersSeed.seed_orders
  end  
end

SeedDb.call_for_create
