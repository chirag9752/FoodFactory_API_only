class CreateHotels < ActiveRecord::Migration[7.1]
  def change
    create_table :hotels do |t|
      t.string :Hotel_name
      t.timestamps
    end
  end
end
