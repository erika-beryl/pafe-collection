class CreateShopPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_payments do |t|

      t.timestamps
    end
  end
end
