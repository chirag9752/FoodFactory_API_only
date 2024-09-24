class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
    respond_to :json

    def create
      # If Authorization header is present, check if the user is already logged in
      if response.headers['Authorization'].present?
        current_token = request.headers['Authorization'].split(' ').last
        jwt_payload = JWT.decode(current_token, Rails.application.credentials.devise_jwt_secret_key!).first
        current_user_id = jwt_payload['sub']
  
        if current_user_id == current_user.id
          render json: {
            status: {
              code: 200, message: "You are already logged in.",
              data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
            }
          }, status: :ok
        else
          # Proceed with the login for another user if the token doesn't match
          super
        end
      else
        # If no Authorization token is present, proceed with login
        super
      end
    end

      # def create
      #   # Extract email and password from the request
      #   email = params[:user][:email]
      #   password = params[:user][:password]
    
      #   # Find the user by email
      #   user = User.find_by(email: email)
    
      #   if user && user.valid_password?(password)
      #     # If the user exists and the password is correct, sign in the user
      #     sign_in(user)
    
      #     render json: {
      #       status: {
      #         code: 200,
      #         message: 'Logged in successfully.',
      #         data: { user: UserSerializer.new(user).serializable_hash[:data][:attributes] }
      #       }
      #     }, status: :ok
      #   else
      #     # If the credentials are incorrect, respond with an error
      #     render json: {
      #       status: {
      #         code: 401,
      #         message: 'Invalid email or password.'
      #       }
      #     }, status: :unauthorized
      #   end
      # end
    

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
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    end
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
