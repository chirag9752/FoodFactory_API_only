class UsersController < ApplicationController        

  before_action :authenticate_user!
  before_action :set_user, only: [:update, :show] 
  load_and_authorize_resource

  def index
    users = User.all
    if current_user.role == "admin"
      render json: all_users_data(users) , status: :ok
    else
      render json: {errors: "Only admin can access this routes"}, status: :unprocessable_entity
    end
  end
        
  def show
    render json: { user: @user }, status: :ok
  end

  def update
    if @user.id == current_user.id
      if @user.update(user_params)
        render json: {message: 'user updated successfully', user: @user}, status: :ok
      else
        render json: {errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: {message: "You can only edit only your profile not others"}, status: :forbidden
    end
  end

  private

  def set_user  
    if params[:id].present?
      @user = User.find(params[:id])
    else
      render json: { error: 'User ID not provided' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
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