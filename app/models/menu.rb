class Menu < ApplicationRecord
  validates :menu_name, :hotel_id, :price, presence: true
  has_many :order_items, dependent: :destroy
  belongs_to :hotel
end
