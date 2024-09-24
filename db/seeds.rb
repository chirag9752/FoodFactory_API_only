User.destroy_all
Hotel.destroy_all
Menu.destroy_all
Order.destroy_all

class Seeds
  def call_for_create
    CreateUsersSeed.seed_users
    CreateHotelsSeed.seed_hotels
    CreateMenusSeed.seed_menus
    create_orders_seed = CreateOrdersSeed.new
    create_orders_seed.create_orders
  end  
end

seed_object = Seeds.new
seed_object.call_for_create


































# def create_users
  #   puts "seeding users"
  
  #   admin = User.create!(
  #     name: "Admin",
  #     email: "admin@example.com",
  #     password: "password",
  #     password_confirmation: "password",
  #     role: :admin
  #   )
  
  #   hotel_owner = User.create!(
  #     name: "Hotel owner",
  #     email: "hotelowner@example.com",
  #     password: "password",
  #     password_confirmation: "password",
  #     role: :hotel_owner
  #   )
  
  #   10.times do |i|
  #     User.create!(
  #       name: Faker::Name.name,
  #       email: Faker::Internet.email,
  #       password: "password",
  #       password_confirmation: "password",
  #       role: :client
  #     )
  #   end
  
  #   puts "Created #{User.count} users"
  # end
  
  # def create_hotels
  #   puts "seeding Hotels"
  
  #   User.hotel_owner.each do |owner|
  #     3.times do 
  #       Hotel.create!(
  #         Hotel_name: Faker::Restaurant.name,
  #         user: owner
  #       )
  #     end
  #   end
  
  #   puts "Created #{Hotel.count} hotels"
  # end
  
  # def create_menus
  #   puts "Seeding Menus..."
  
  #   Hotel.all.each do |hotel|
  #     5.times do
  #       Menu.create!(
  #         menu_name: Faker::Food.dish,
  #         description: Faker::Food.description,
  #         price: rand(100..300),
  #         hotel: hotel
  #       )
  #     end
  #   end
  
  #   puts "Created #{Menu.count} menus"
  # end
  
  # def create_orders
  #   puts "Seeding orders"
  
  #   clients = User.client
  #   hotels = Hotel.all
  
  #   clients.each do |client|
  #     3.times do
  #       order = Order.create!(
  #         user: client,
  #         hotel: hotels.sample,    # .sample is a Ruby method that selects a random element from an array.
  #         total_price: 0
  #       )
  
  #       create_order_items(order)
  #     end
  #   end
  
  #   puts "Created #{Order.count} orders."
  # end
  
  # def create_order_items(order)
  #   puts "Seeding order Items for Order #{order.id}"
  
  #   menu_items = order.hotel.menus.sample(3)
  #   total_price = 0
  
  #   menu_items.each do |menu|
  #     quantity = rand(1..3)
  #     OrderItem.create!(
  #       order: order,
  #       menu: menu,
  #       quantity: quantity,
  #       price: menu.price * quantity
  #     )
  #     total_price += menu.price * quantity
  #   end
  
  #   order.update!(total_price: total_price)
  
  #   puts "Created #{OrderItem.where(order: order).count} orders for Order #{order.id}"
  # end