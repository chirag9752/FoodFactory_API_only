class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :hotels
  has_many :orders

  enum role: {
      admin: 0,
      client: 1,
      hotel_owner: 2
    }
end
