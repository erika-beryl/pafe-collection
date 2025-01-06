class Opentime < ApplicationRecord
  has_many :shop_opentimes
  has_many :shops, through: :shop_opentimes

  enum weekly: { 日: 0, 月: 1, 火: 2, 水: 3, 木: 4, 金: 5, 土: 6 }

end
