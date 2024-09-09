class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.string :menu_name
      t.timestamps
    end
  end
end
