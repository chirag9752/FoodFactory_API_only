class HotelsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_hotel, only: [:show, :update, :destroy]
  before_action :set_user, only: [:create , :index]
  load_and_authorize_resource

  def index
    render json: indexObjectMaker(@user)
  end

  def show
    render json: @hotel
  end

  def create
    @hotel = @user.hotels.build(hotel_params) 
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

  def set_user
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    else
      render json: { error: 'User ID not provided' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound  #f the user ID is provided but doesn't exist in the database
    render json: { error: 'User not found' }, status: :not_found
  end

  def set_hotel
    if params[:id].present?
      @hotel = Hotel.find(params[:id])
    else
      render json: {error: 'Hotel Id not provided'}
    end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Hotel not found'}, status: :not_found
  end

  def indexObjectMaker(user)
    if user.role == "client" || user.role == "admin"  # Assuming role is a string; use appropriate value
      @hotels = Hotel.all
    else
      @hotels = user.hotels.all
    end
    @mapped_hotels = @hotels.map do |hotel|
      {
        id: hotel.id,
        name: hotel.Hotel_name,
        user_id: hotel.user_id
      }
    end
     @mapped_hotels
  end

  def hotel_params
    params.require(:hotel).permit(:Hotel_name)
  end
end
