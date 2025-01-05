class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :postal_code, null: false
      t.string :prefecture, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :other_address
      t.string :full_address, null: false
      t.string :tel, null:false
      t.boolean :reservation
      t.boolean :parking

      t.timestamps
    end
  end
end
