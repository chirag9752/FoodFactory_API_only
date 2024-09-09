class Order < ApplicationRecord
    belongs_to :user
    belongs_to :hotel
    has_many :order_items
end
