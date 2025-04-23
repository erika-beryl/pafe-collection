class AddCloudinaryPublicIdToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :cloudinary_public_id, :string
  end
end
