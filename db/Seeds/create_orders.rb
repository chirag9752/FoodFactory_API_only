class CreateOrdersSeed
	def create_orders
    puts "Seeding orders"
    clients = User.client
    hotels = Hotel.all
  
    clients.each do |client|
      3.times do
        order = Order.create!(
          user: client,
          hotel: hotels.sample,    # .sample is a Ruby method that selects a random element from an array.
          total_price: 0
        )
  
        create_order_items(order)
      end
    end
  
    puts "Created #{Order.count} orders."
  end
  
  def create_order_items(order)
    puts "Seeding order Items for Order #{order.id}"
  
    menu_items = order.hotel.menus.sample(3)
    total_price = 0
  
    menu_items.each do |menu|
      quantity = rand(1..3)
      OrderItem.create!(
        order: order,
        menu: menu,
        quantity: quantity,
        price: menu.price * quantity
      )
      total_price += menu.price * quantity
    end
  
    order.update!(total_price: total_price)
  
    puts "Created #{OrderItem.where(order: order).count} orders for Order #{order.id}"
  end
end