class CheckoutController < ApplicationController

  def create_session
    order = Order.find(params[:order_id])

    line_items = order.order_items.map do |item|
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: item.menu.name
          },
          unit_amount: (item.menu.price * 100).to_i,
        },
        quantity: item.quantity
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_type: ['card'],
      line_items: line_items
      mode: 'payment', 
      success_url: root_url,
      cancel_url: root_url,
    )

    render json: { id: session.id }
  end
end
