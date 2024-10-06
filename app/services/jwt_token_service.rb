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
  SECRET_KEY = Rails.application.secret_key_base.to_s

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    Rails.logger.info "Encoding JWT with payload: #{payload.inspect}"
    token = JWT.encode(payload, SECRET_KEY)
    Rails.logger.info "Generated token: #{token}"
    token
  end

  def self.decode(token)
    Rails.logger.info "Decoding token: #{token}"
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      Rails.logger.info "Decoded payload: #{decoded.inspect}"
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::ExpiredSignature
      Rails.logger.error "JWT token has expired"
      nil
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decoding failed: #{e.message}"
      nil
    end
  end
end

  