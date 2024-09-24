class OrderItem < ApplicationRecord
  validates :order_id, :menu_id, :quantity, :price, presence: true
  belongs_to :order
  belongs_to :menu
end
