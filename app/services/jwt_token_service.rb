# # app/services/jwt_token_service.rb
# class JwtTokenService
#   SECRET_KEY = Rails.application.secret_key_base.to_s
  
#   def self.encode(payload, exp = 24.hours.from_now)
#     payload[:exp] = exp.to_i
#     JWT.encode(payload, SECRET_KEY)
#   end
  
#   def self.decode(token)
#     byebug
#     decoded = JWT.decode(token, SECRET_KEY)[0]
#      HashWithIndifferentAccess.new(decoded)
#   rescue JWT::DecodeError
#     nil
#   end
# end

class JwtTokenService
  SECRET_KEY = Rails.application.credentials.devise_jwt_secret_key! || Rails.application.secret_key_base.to_s

  def self.encode(payload, exp = 24.hours.from_now)
    jti = SecureRandom.uuid # Generate a unique identifier for the token
    payload[:jti] = jti
    payload[:exp] = exp.to_i
    # Rails.logger.info "Encoding token with payload: #{payload} and secret: #{SECRET_KEY}"
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    # Rails.logger.info "Decoding token: #{token} with secret: #{SECRET_KEY}"
    decoded = JWT.decode(token, SECRET_KEY)[0]
    decoded_payload = HashWithIndifferentAccess.new(decoded)    # HashWithIndifferentAccess.new(decoded): This converts the decoded payload into a hash where keys can be accessed as strings or symbols.
    
    # HashWithIndifferentAccess allows you to access the hash using both :symbol and "string" keys interchangeably. This is useful when working with Rails since keys in hashes can sometimes be strings or symbols.
    if blacklisted?(decoded_payload[:jti])
      # Rails.logger.error "Token with jti: #{decoded_payload[:jti]} is blacklisted"
      return nil
    end

    decoded_payload  # If the token is not blacklisted, the decoded payload is returned.
  rescue JWT::ExpiredSignature
    Rails.logger.error "DecodeError: Token has expired"
    nil
  rescue JWT::DecodeError => e
    Rails.logger.error "DecodeError: #{e.message}"
    nil
  rescue => e
    Rails.logger.error "Unexpected error during token decoding: #{e.message}"
    nil
  end

  def self.blacklisted?(jti)
    JwtBlacklist.exists?(jti: jti)
  end
end


  