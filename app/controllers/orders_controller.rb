class OrdersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :destroy]
  before_action :set_user, only: [:destroy , :index, :create]
  before_action :set_hotel, only: [:index, :create]
  load_and_authorize_resource

  def index
    user = @user
    hotel = @hotel
    @orders = checkroles(user, hotel)
    render json: @orders, status: :ok
  end

  def show 
    render json: @order
  end

  def create
    result = create_checkout_service.call
    if result[:status] == :created
      render json: { checkout_url: result[:session].url }, status: :created
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

  def checkroles(user, hotel)
    if user.role == "admin"
      orders = Order.all
    elsif user.role == "hotel_owner"
      orders = hotel.orders
    else
      orders = user.orders
    end
    orders
  end

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
  
  def create_checkout_service
    result = order_items_params
    CreateCheckoutService.new(@user,
                          @hotel,
                          order_params.to_h.deep_symbolize_keys,
                          result[:order_items].map(&:to_h).map(&:deep_symbolize_keys))
  end

  def order_params
    result = order_items_params
    {
      total_price: result[:total_price],
      status: "done"
    }
  end

  def order_items_params
    sum = 0
    order_items = params.require(:order_items).map do |item|
      permitted_item = item.permit(:menu_id, :quantity, :price)
      menu_id = permitted_item[:menu_id].to_i
      menu = Menu.find(menu_id)
      price =  menu.price.to_f
      quantity = permitted_item[:quantity].to_i
      sum = price * quantity
      {
        menu_id: menu_id,
        quantity: quantity.to_i,
        price: price
      }
    end
    {order_items: order_items, total_price: sum }
  end
end