# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



User.destroy_all
Hotel.destroy_all
Menu.destroy_all
Order.destroy_all
OrderItem.destroy_all

admin = User.create!(
  name: 'Farad Agrawal',
  email: 'farad@gmail.com',
  password: '123456',
  password_confirmation: '123456',
  role: "admin"
)


hotel_owner1 = User.create!(
    name: 'paragji',
    email: 'paragji@gmail.com',
    password: '123456',
    password_confirmation: '123456',
    role: "hotel_owner"
)

client1 = User.create!(
    name: 'sunita',
    email: 'sunita@gmail.com',
    password: '123456',
    password_confirmation: '123456',
    role: "client"
)

client2 = User.create!(
    name: 'client2',
    email: 'client2@gmail.com',
    password: '123456',
    password_confirmation: '123456',
    role: "client"
)

hotel1 = Hotel.create!(
  Hotel_name: 'Hotel Sunshine',
  user: hotel_owner1
)


menu1 = Menu.create!(
  menu_name: 'Breakfast Special',
  description: 'A special breakfast menu with pancakes and coffee',
  price: 150,
  hotel: hotel1
)

menu2 = Menu.create!(
  menu_name: 'Lunch Delight',
  description: 'A delightful lunch menu with sandwiches and salads',
  price: 200,
  hotel: hotel1
)

order1 = Order.create!(
  user: client1,
  hotel: hotel1,
  total_price: 500,
  status: 'pending'
)

OrderItem.create!(
  order: order1,
  menu: menu1,
  quantity: 2,
  price: menu1.price
)

OrderItem.create!(
  order: order1,
  menu: menu2,
  quantity: 1,
  price: menu2.price
)