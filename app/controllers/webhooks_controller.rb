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
      result = CreateOrderService.new(session).call
      
      if result[:success]
        render json: { message: "Order successfully created" }, status: :ok
      else
        render json: { message: 'Order creation failed', errors: result[:errors] }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Unhandled event type' }, status: :ok
    end
  end
end
