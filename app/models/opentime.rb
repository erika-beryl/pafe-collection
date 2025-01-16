class Opentime < ApplicationRecord
  has_many :shop_opentimes
  has_many :shops, through: :shop_opentimes
end
