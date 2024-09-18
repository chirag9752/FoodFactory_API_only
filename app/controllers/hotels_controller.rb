class HotelsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_hotel, only: [:show , :update, :destroy]
  before_action :set_user, only: [:index]
  load_and_authorize_resource

  def index
    if @user.nil?
      render json: { message: "User not authenticated" }, status: :unauthorized
      return
    end
    
    if @user.role == "client" || @user.role == "admin"  # Assuming role is a string; use appropriate value
      @hotels = Hotel.all

      @mapped_hotels = @hotels.map do |hotel|
      {
        name: hotel.Hotel_name,
        user_id: hotel.user_id
      }
    end
      
      # @hotels = Hotel.all
    else
      @hotels = @user.hotels.all

      @mapped_hotels = @Hotels.map do |hotel|
      {
        name: hotel.Hotel_name,
        user_id: hotel.user_id
      }
    end
      
    end

    render json: @mapped_hotels
  end

  def show
    render json: @hotel
  end

  def create
    @hotel = current_user.hotels.build(hotel_params)  # Use current_user to associate the hotel with the authenticated user
        
    if @hotel.save
      render json: @hotel, status: :created
    else
      render json: @hotel.errors, status: :unprocessable_entity
    end
  end
    

  def update
    if @hotel.update(hotel_params)
      render json: @hotel
    else
      render json: @hotel.errors, status: :unprocessable_entity
    end
  end

  def destroy
    hotel_name = @hotel.Hotel_name
    if @hotel.destroy
      render json: { message: "#{hotel_name} hotel was deleted successfully"}, status: :ok
    else
      render json: @hotel.errors, status: :unprocessable_entity
    end
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def hotel_params
    params.require(:hotel).permit(:Hotel_name)
  end
end
