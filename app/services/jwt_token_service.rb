# app/services/jwt_token_service.rb
class JwtTokenService
  SECRET_KEY = Rails.application.secret_key_base.to_s
  
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
     HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
  