class MenusController < ApplicationController

  before_action :authenticate_user!
  before_action :set_menu, only: [:show, :update, :destroy]
  before_action :set_hotel, only: [:create, :index]
  before_action :set_user, only: [:index]
  load_and_authorize_resource

  def index
    if @user.role == "hotel_owner"
      menus = @hotel.menus.all
    else
      menus = Menu.all
    end
      render json: create_object_index(menus), status: :ok
  end

  def show
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
      render json: @menu , status: :ok
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

  def set_user  
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    else
      render json: { error: 'User ID not provided' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound  #f the user ID is provided but doesn't exist in the database
    render json: { error: 'User not found' }, status: :not_found
  end
  
  def set_menu
    if params[:id].present?
      @menu = Menu.find(params[:id])
    else
      render json: {error: 'Menu Id not provided'}, status: :bad_request
    end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Menu not found' }, status: :not_found
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
    if params[:hotel_id].present?
      @hotel = Hotel.find(params[:hotel_id])
    else
      render json: {error: 'Hotel Id not provided'}
    end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Hotel not found'}, status: :not_found
  end

  def menu_params
    params.require(:menu).permit(:menu_name , :description, :price)
  end
end