class Payment < ApplicationRecord
  has_many :shop_payments
  has_many :shops, through: :shops
end
