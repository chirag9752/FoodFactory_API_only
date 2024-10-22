class CreateOrderService
  
  def initialize(session)
    @session = session
  end

  def call
    begin
      user_id = @session.metadata.user_id
      hotel_id = @session.metadata.hotel_id
      order_params = JSON.parse(@session.metadata.order_params)
      order_items = JSON.parse(@session.metadata.order_items)

      user = User.find(user_id)
      hotel = Hotel.find(hotel_id)
      
      ActiveRecord::Base.transaction do
        order = user.orders.new(order_params.merge(hotel_id: hotel.id, status: 'done'))
        if order.save
          create_order_items(order, order_items)
          return { success: true, order: order }
        else
          log_error("Order creation failed", order.errors.full_messages)
          raise ActiveRecord::Rollback, "Order creation failed"
        end
      end
    rescue ActiveRecord::RecordNotFound => e
      log_error("Record not found", e.message)
      return { success: false, errors: "Record not found: #{e.message}" }
    rescue JSON::ParserError => e
      log_error("JSON parsing failed", e.message)
      return { success: false, errors: "Invalid json #{e.message}" }
    rescue => e
      log_error("unexpected error is coming", e.message)
      return { success: false, errors: "An unexpected error is coming #{e.message}" }
    end
  end

  private

  def create_order_items(order , order_items)
    order_items.each do |item|
      order.order_items.create!(
        menu_id: item['menu_id'],
        quantity: item['quantity'],
        price: item['price']
      )
    rescue ActiveRecord::RecordInvalid => e
      log_error("OrderItem creation failed", e.message)
      raise ActiveRecord::Rollback, "Order item creation failed: #{e.message}"
    end
  end

  def log_error(message, details)
    Rails.logger.error("#{message}: #{details}")
  end
end
