class ApplicationController < ActionController::API
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name role])
  end

  private

  # def authenticate_user!
  #   byebug
  #   token = request.headers['Authorization']&.split(' ')&.last # Extract token from Authorization header
  #   decoded_token = JwtTokenService.decode(token) # Decode the token using your JwtTokenService

  #   if decoded_token.nil?
  #     render json: { error: 'Not Authorized' }, status: :unauthorized
  #   end
  # end
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    
    if token.nil?
      return render json: { error: 'Token is missing' }, status: :unauthorized
    end
    decoded_token = JwtTokenService.decode(token)
    if decoded_token.nil?
      return render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  end
end