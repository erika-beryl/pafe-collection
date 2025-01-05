class CreateOpentimes < ActiveRecord::Migration[7.1]
  def change
    create_table :opentimes do |t|
      t.boolean :is_open
      t.integer :weekly
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
