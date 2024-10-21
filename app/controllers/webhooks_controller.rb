class WebhooksController < ApplicationController

  # do this before inside download because your stripe is there
  #  ./stripe listen --forward-to localhost:3000/webhooks/stripe

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    endpoint_secret = ENV["END_POINT_SECRET"]
    
    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { message: e.message }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { message: e.message }, status: 400 and return
    end
    
    if event['type'] == 'checkout.session.completed'

      session = event['data']['object']
      
      user_id = session.metadata.user_id
      hotel_id = session.metadata.hotel_id
      order_params = JSON.parse(session.metadata.order_params)
      order_items = JSON.parse(session.metadata.order_items)

      user = User.find(user_id)
      hotel = Hotel.find(hotel_id)
      order = user.orders.new(order_params.merge(hotel_id: hotel.id, status: 'done'))
       

      if order.save
        order_items.each do |item|
          order.order_items.create!(
            menu_id: item['menu_id'],
            quantity: item['quantity'],
            price: item['price']
          )
        end
      else
        Rails.logger.error("Order creation failed: #{order.errors.full_messages}")
      end
    end
      
    render json: { message: 'Success' }, status: :ok
  end
  
end
