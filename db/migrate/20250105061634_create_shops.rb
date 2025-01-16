class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :postal_code, null: false
      t.integer :prefecture_code, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :other_address
      t.string :full_address, null: false
      t.string :tel, null:false
      t.boolean :reservation, null: false, default: false
      t.boolean :parking, null: false, default: false
      t.decimal :latitude
      t.decimal :longitude
      t.timestamps
    end
  
    add_index :shops, :name, unique: true
    add_index :shops, :postal_code, unique: true
  end
end
