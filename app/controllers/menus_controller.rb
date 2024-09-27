class MenusController < ApplicationController

  before_action :authenticate_user!
  before_action :set_menu, only: [:show, :update, :destroy]
  before_action :set_hotel, only: [:create, :index]
  load_and_authorize_resource
  
  def index
    menus = @hotel.menus.all
    render json: create_object_index(menus), status: :ok
  end

  def show+
    render json: @menu
  end
  
  def create
    @menu = @hotel.menus.build(menu_params)
    if @menu.save
      render json: @menu, status: :created
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end
  
  def update
    if @menu.update(menu_params)
      render json: @menu , status: :created
    else
      render json: @menu.errors , status: :unprocessable_entity
    end
  end
  
  def destroy
    menu_name = @menu.menu_name
    if @menu.destroy 
      render json: {message: "#{menu_name} is deleted successfully"}, status: :ok
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_menu
    @menu = Menu.find(params[:id])
  end

  def create_object_index(menus)
    @mapped_menus = menus.map do |menu|
      {
        menu_id: menu.id,
        name: menu.menu_name,
        hotel_id: menu.hotel_id,
        details: menu.description,
        price: menu.price
      }
    end
    @mapped_menus
  end

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def menu_params
    params.require(:menu).permit(:menu_name , :description, :price)
  end
end