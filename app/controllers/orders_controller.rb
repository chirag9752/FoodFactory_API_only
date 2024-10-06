class OrdersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :destroy]
  before_action :set_user, only: [:destroy]
  load_and_authorize_resource

  def index
    @orders = Order.all
    render json: @orders
  end

  def show 
    render json: @order
  end

  def create
    @hotel = Hotel.find_by(id: params[:hotel_id])
    result = createOrderService
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
  

  def createOrderService
    service = CreateOrderService.new(current_user, @hotel, order_params, params[:order_items])
    return result = service.call
  end

  def objectForOrder(result)
    {
      order_id: result[:order].id,
      status: result[:order].status,
      total_price: result[:order].total_price,
      order_items: result[:order_items]
    }
  end

  def order_params
    params.require(:order).permit(:total_price, :status)
  end
	
end        
