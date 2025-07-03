class ShopPayment < ApplicationRecord
  belongs_to :payment
  belongs_to :shop

  validates :shop_id, uniqueness: { scope: :payment_id }
end
