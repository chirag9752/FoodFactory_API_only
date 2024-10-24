class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include EmailSender

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,jwt_revocation_strategy: self

  validates :name, :role, :email, :password, presence: true
  after_create :send_welcome_email

  has_many :hotels, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {
      admin: 0,
      client: 1,
      hotel_owner: 2
    }
end
