class OrdersController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :destroy]
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
    if @order.user == current_user
      @order.destroy
      render json: { message: "Order successfully deleted"}, status: :ok
    else
      render json: { error: "you are not authorize to delete this order"}, status: :forbidden
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
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
