class Hotel < ApplicationRecord
    has_many :menus, dependent: :destroy
    has_many :orders, through: :menus
    belongs_to :user
end
