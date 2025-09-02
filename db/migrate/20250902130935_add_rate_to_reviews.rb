class AddRateToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :rate, :float
  end
end
