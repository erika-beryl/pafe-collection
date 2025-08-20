class AddUserToParfaits < ActiveRecord::Migration[7.1]
  def change
    add_reference :parfaits, :user, null: false, foreign_key: true
  end
end
