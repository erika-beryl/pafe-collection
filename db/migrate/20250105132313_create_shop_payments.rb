class CreateShopPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_payments do |t|
      t.references :shop, index: true, foreign_key: true
      t.references :payment, index: true, foreign_key: true

      t.timestamps
    end
  end
end
