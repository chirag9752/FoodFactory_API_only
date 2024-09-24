class Order < ApplicationRecord
  validates :user_id, :hotel_id, :total_price, :status, presence: true
  belongs_to :user
  belongs_to :hotel
  has_many :order_items, dependent: :destroy
end
