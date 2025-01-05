class Opentime < ApplicationRecord
  has_many :shop_opentimes
  has_many :shop, through: :shop_opentimes
end
