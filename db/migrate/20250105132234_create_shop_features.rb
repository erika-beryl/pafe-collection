class CreateShopFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_features do |t|
      t.references :shop, index: true, foreign_key: true
      t.references :feature, index: true, foreign_key: true

      t.timestamps
    end
  end
end
