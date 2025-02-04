class CreateParfaits < ActiveRecord::Migration[7.1]
  def change
    create_table :parfaits do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price, null: false
      t.text :body
      t.boolean :is_limited, default: false, null: false

      t.timestamps
    end
  end
end
