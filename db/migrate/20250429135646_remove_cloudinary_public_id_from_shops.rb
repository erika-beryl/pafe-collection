class RemoveCloudinaryPublicIdFromShops < ActiveRecord::Migration[7.1]
  def change
    remove_column :shops, :cloudinary_public_id, :string
  end
end
