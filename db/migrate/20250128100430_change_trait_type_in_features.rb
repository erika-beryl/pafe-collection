class ChangeTraitTypeInFeatures < ActiveRecord::Migration[7.1]
  def change
    change_column :features, :trait, :string
  end
end
