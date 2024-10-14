require 'stripe'

class StripeService
  def initialize()
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end

  def find_or_create_customer(customer)  
  end
end