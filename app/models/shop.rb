class Shop < ApplicationRecord
  include JpPrefecture
  jp_prefecture :prefecture_code

  has_many :shop_opentimes, dependent: :destroy
  has_many :opentimes, through: :shop_opentimes
  has_many :shop_payments, dependent: :destroy
  has_many :payments, through: :shop_payments
  has_many :shop_features, dependent: :destroy
  has_many :features, through: :shop_features
  accepts_nested_attributes_for :opentimes

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :postal_code, presence:true, uniqueness: true, format: {with: /\A[0-9]+\z/, message: "is invalid. Please input half-width characters."}
  validates :prefecture_code, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true, uniqueness: true
  before_save :generate_address

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  private

  def generate_address
    # buildingが空の場合は除外してaddressを生成
    self.full_address = [prefecture_name, city, street, other_address.presence].compact.join(" ")
  end

end
