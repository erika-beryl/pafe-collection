class Shop < ApplicationRecord
  has_many :shop_opentimes, dependent: :destroy
  has_many :opentimes, through: :shop_opentimes
  has_many :shop_payments, dependent: :destroy
  has_many :payments, through: :shop_payments
  has_many :shop_features, dependent: :destroy
  has_many :features, through: :shop_features
  accepts_nested_attributes_for :opentimes

  validates :name, presence: true, length: { maximum: 100 },  uniqueness: true
  validates :postal_code, presence:true, uniqueness: true
  validates :prefecture, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true
  before_save :generate_address

  private

  def generate_address
    # buildingが空の場合は除外してaddressを生成
    self.full_address = [prefecture, city, street, other_address.presence].compact.join(" ")
  end

end
