class Users::SessionsController < Devise::SessionsController
  
  include RackSessionsFix
  respond_to :json

  def create
    email = params[:user][:email]
    password = params[:user][:password]
    user = User.find_by(email: email)
    if user && user.valid_password?(password)
      sign_in(user)
      token = JwtTokenService.encode(user_id: user.id)
      UserMailerJob.perform_later(user)
      render json: {
      status: {
      code: 200,
      message: 'Logged in successfully.',
      data: { user: UserSerializer.new(user).serializable_hash[:data][:attributes].merge(jwt: token) }
      }
    }, status: :ok
    else
      render json: {
      status: {
      code: 401,
      message: 'Invalid email or password.'
      }
    }, status: :unauthorized
    end
  end

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      decoded_token = JwtTokenService.decode(token)
      
      if decoded_token
        JwtBlacklist.create!(jti: decoded_token[:jti], exp: Time.at(decoded_token[:exp]))
        render json: {
          status: 200,
          message: "Logged out successfully"
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Invalid token or user already logged out."
        }, status: :unauthorized
      end
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end

  end
  
  





  # def create
  #   # If Authorization header is present, check if the user is already logged in
  #   if response.headers['Authorization'].present?
  #   current_token = request.headers['Authorization'].split(' ').last
  #   jwt_payload = JWT.decode(current_token, Rails.application.credentials.devise_jwt_secret_key!).first
  #   current_user_id = jwt_payload['sub']
  
  #   if current_user_id == current_user.id
  #     render json: {
  #   status: {
  #     code: 200, message: "You are already logged in.",
  #     data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
  #   }
  #     }, status: :ok
  #   else
  #     # Proceed with the login for another user if the token doesn't match
  #     super
  #   end
  #   else
  #   # If no Authorization token is present, proceed with login
  #   super
  #   end
  # end
end







