class AddHotelIdToMenus < ActiveRecord::Migration[7.1]
  def change
    add_reference :menus, :hotel, null: false, foreign_key: true
  end
end
