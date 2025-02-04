class CreateBusinesses < ActiveRecord::Migration[7.1]
  def change
    create_table :businesses do |t|
      t.string :business_time
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end
