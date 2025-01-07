class Opentime < ApplicationRecord
  has_many :shop_opentimes
  has_many :shops, through: :shop_opentimes

  enum weekly: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }

end
