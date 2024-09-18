class AddTotalPriceAndStatusToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :total_price, :integer
    add_column :orders, :status, :string
  end
end
