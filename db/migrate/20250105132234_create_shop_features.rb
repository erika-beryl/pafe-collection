class CreateShopFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_features do |t|

      t.timestamps
    end
  end
end
