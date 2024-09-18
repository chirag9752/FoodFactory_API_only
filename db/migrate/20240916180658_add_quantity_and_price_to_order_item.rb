class AddQuantityAndPriceToOrderItem < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :quantity, :string
    add_column :order_items, :price, :integer
  end
end
