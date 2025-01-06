class Payment < ApplicationRecord
  has_many :shop_payments
  has_many :shops, through: :shop_payments

  enum method_type: { カード可: 1, 電子マネー可: 2, QRコード決済可: 3 }
end
