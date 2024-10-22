class CreateCheckoutService
  def initialize(user, hotel, order_params, order_items)
    @user = user
    @hotel = hotel
    @order_params = order_params
    @order_items = order_items
  end

  def call
    line_items = @order_items.map do |item|
      menu_item = Menu.find(item[:menu_id])
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: menu_item.menu_name
          },
          unit_amount: (menu_item.price * 100).to_i
        },
        quantity: item[:quantity]
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      metadata: {
          user_id: @user.id,
          hotel_id: @hotel.id,
          order_params: @order_params.to_json,
          order_items: @order_items.to_json
        },
      success_url: "http://127.0.0.1:3000",
      cancel_url: "http://127.0.0.1:3000"
    )

    { session: session, status: :created}
  rescue StandardError => e
    { errors: e.message, status: :unprocessable_entity }
  end
end
