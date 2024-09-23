class UsersController < ApplicationController        
  
  before_action :authenticate_user!, except: [:index]  # Require authentication except for registration
  before_action :set_user, only: [:update]  # Require authentication except for registration
  load_and_authorize_resource
  
  def index
    users = User.all
    render json: all_users_data(users) , status: :ok
  end
        
  def show
    render json: { user: current_user }, status: :ok
  end
      
  def update
    if @user.update(user_params)
      render json: {message: 'user updated successfully', user: @user}, status: :ok
    else
      render json: {errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def all_users_data(users)
    users_data = users.map do |user|
      {
        id: user.id,
        name: user.name,
        role: user.role
      }
    end
    users_data
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :role)
  end
end