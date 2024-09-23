class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :hotels, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {
      admin: 0,
      client: 1,
      hotel_owner: 2
    }

  # validates :role, inclusion: { in: roles.keys, message: "%{value} is not a valid role" }
  # before_validation :restrict_admin_role, on: :create
  
  # private
  
  # def restrict_admin_role
  #   if role == "admin"
  #     errors.add(:role, "cannot be assigned as a admin")
  #   end
  # end
end
