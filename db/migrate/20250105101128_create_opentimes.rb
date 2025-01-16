class CreateOpentimes < ActiveRecord::Migration[7.1]
  def change
    create_table :opentimes do |t|
      t.text :business_hours
    
      t.timestamps
    end
  end
end
