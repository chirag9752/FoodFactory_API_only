class OrderItemsController < ApplicationController

  before_action :authenticate_user!, expect: [:index]

  def index
    @order_items = OrderItem.all
    render json: @order_items
  end

  def show
    @order = Order.find(params[:order_id])
    render json: @order.order_items
  end
end
  