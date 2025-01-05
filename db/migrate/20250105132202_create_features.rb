class CreateFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :features do |t|

      t.timestamps
    end
  end
end
