class ShopFeature < ApplicationRecord
  belongs_to :feature
  belongs_to :shop

  validates :shop_id, uniqueness: { scope: :feature_id }
end
