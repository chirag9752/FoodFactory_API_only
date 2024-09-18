class AddDescriptionAndPriceToMenu < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :description, :string
    add_column :menus, :price, :integer
  end
end
