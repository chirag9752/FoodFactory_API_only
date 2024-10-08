class OrdersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :destroy]
  before_action :set_user, only: [:destroy , :index]
  before_action :set_hotel, only: [:index, :create]
  load_and_authorize_resource

  def index
    if @user.role == "admin"
      @orders = Order.all
    elsif @user.role == "hotel_owner"
      @orders = @hotel.orders
    else
      @orders = @user.orders
    end
    render json: @orders, status: :ok
  end

  def show 
    render json: @order
  end

  def create
    result = create_order_service.call
    if result[:status] == :created
      render json: { order: objectForOrder(result) }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @order.user.id == @user.id
      @order.destroy
      render json: { message: "Order successfully deleted"}, status: :ok
    else
      render json: { error: "you are not authorize to delete this order"}, status: :forbidden
    end
  end

  private

  def set_hotel
    if params[:hotel_id].present?
      @hotel = Hotel.find(params[:hotel_id])
    else
      render json: {error: 'Hotel Id not provided'}
    end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Hotel not found'}, status: :not_found
  end

  def set_user  
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    else
      render json: { error: 'User ID not provided' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound  #f the user ID is provided but doesn't exist in the database
    render json: { error: 'User not found' }, status: :not_found
  end
  
  def set_order
    @order = Order.find_by(id: params[:id])
    unless @order
      render json: { error: "Order not found with id: #{params[:id]}" }, status: :not_found
    end
  end
  
  def create_order_service
    CreateOrderService.new(current_user,
                          @hotel,
                          order_params.to_h.deep_symbolize_keys,
                          order_items_params.map(&:to_h).map(&:deep_symbolize_keys))
  end

  def objectForOrder(result)
    {
      order_id: result[:order].id,
      status: result[:order].status,
      total_price: result[:order].total_price,
      order_items: result[:order_items]
    }
  end

    # def order_params
    #   params.require(:order).permit(:total_price, :status)
    # end
    def order_params
      permitted_params = params.require(:order).permit(:total_price, :status)
      # Convert total_price to float
      {
        total_price: permitted_params[:total_price].to_f,
        status: permitted_params[:status]
      }
    end
    
  # def order_items_params
  #   params.require(:order_items).map do |item|
  #     item.permit(:menu_id, :quantity, :price)
  #   end
  # end

  def order_items_params
    params.require(:order_items).map do |item|
      # Use permit to whitelist the fields
      permitted_item = item.permit(:menu_id, :quantity, :price)
      
      # Convert the parameters to appropriate types
      {
        menu_id: permitted_item[:menu_id].to_i,
        quantity: permitted_item[:quantity].to_i,
        price: permitted_item[:price].to_f
      }
    end
  end
  
	
end        
