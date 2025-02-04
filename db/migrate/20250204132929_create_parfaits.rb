class CreateParfaits < ActiveRecord::Migration[7.1]
  def change
    create_table :parfaits do |t|

      t.timestamps
    end
  end
end
