class OrderItemsController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @order_items = OrderItem.all
    render json: @order_items
  end
end
  