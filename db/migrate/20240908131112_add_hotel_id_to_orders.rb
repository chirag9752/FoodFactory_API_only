class AddHotelIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :hotel
  end
end
