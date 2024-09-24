class Hotel < ApplicationRecord
  validates :Hotel_name, :user_id, presence: true
  has_many :menus, dependent: :destroy
  has_many :orders, through: :menus
  belongs_to :user
end
