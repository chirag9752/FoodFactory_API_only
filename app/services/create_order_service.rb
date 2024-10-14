# app/services/create_order_service.rb
class CreateOrderService
  def initialize(user, hotel, order_params, order_items)
    @user = user
    @hotel = hotel
    @order_params = order_params
    @order_items = order_items
  end

  # def call
  #   # Create the order with the provided parameters
  #   order = @user.orders.new(@order_params.merge(hotel_id: @hotel.id))
    
  #   if order.save
  #     # Create associated order items
  #     @order_items.each do |item|
  #       order.order_items.create!(
  #         menu_id: item[:menu_id], 
  #         quantity: item[:quantity], 
  #         price: item[:price]
  #       )
  #     end
  #     # Return the created order and items
  #     {
  #       order: order,
  #       status: :created,
  #       order_items: order.order_items.map do |item|
  #         menu = Menu.find(item.menu_id)
  #         {
  #           menu_id: item.menu_id,
  #           menu_name: menu.menu_name,
  #           quantity: item.quantity,
  #           price: item.price
  #         }
  #       end
  #     }
  #   else
  #     # Return the error messages if the order creation fails
  #     { errors: order.errors.full_messages, status: :unprocessable_entity }
  #   end
  # end

  def call
    line_items = @order_items.map do |item|
      menu_item = Menu.find(item[:menu_id])
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: menu_item.menu_name
          },
          unit_amount: (menu_item.price * 100).to__i
        },
        quantity: item[:quantity]
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_type: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: root_url,
      cancel_url: root_url,
      metadata: {
        user_id: @user.id,
        hotel_id: @hotel.id,
        order_params: @order_params.to_json,
        order_items: @order_items.to_json
      }
    )

    { session: session, status: :created}
  rescue StandardError => e
    { errors: e.message, status: :unprocessable_entity }
  end
end
