class CreateShopOpentimes < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_opentimes do |t|
      t.references :shop, index: true, foreign_key: true
      t.references :opentime, index: true, foreign_key: true

      t.timestamps
    end
  end
end
