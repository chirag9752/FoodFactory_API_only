class Order < ApplicationRecord
  validates :user_id, :hotel_id, :status, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :user
  belongs_to :hotel
  has_many :order_items, dependent: :destroy
end
