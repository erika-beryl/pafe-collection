class CreateShopOpentimes < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_opentimes do |t|

      t.timestamps
    end
  end
end
