class Menu < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :hotel
end
