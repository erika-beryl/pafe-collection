class ChangeMethodTypeTypeInPayments < ActiveRecord::Migration[7.1]
  def change
    change_column :payments, :method_type, :string
  end
end
