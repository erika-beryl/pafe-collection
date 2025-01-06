class ShopOpentime < ApplicationRecord
  belongs_to :opentime, dependent: :destroy
  belongs_to :shop
end


