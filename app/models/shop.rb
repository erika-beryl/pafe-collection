class Shop < ApplicationRecord
  include JpPrefecture
  jp_prefecture :prefecture_code

  has_many :shop_opentimes, dependent: :destroy
  has_many :opentimes, through: :shop_opentimes
  has_many :shop_payments, dependent: :destroy
  has_many :payments, through: :shop_payments
  has_many :shop_features, dependent: :destroy
  has_many :features, through: :shop_features
  has_one :business, dependent: :destroy

  has_many :parfaits, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :postal_code, presence: true, uniqueness: true, format: {with: /\A\d{7}\z/, message: "は7桁の半角数字で入力してください" }
  validates :prefecture_code, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true, uniqueness: true
  before_save :generate_address

  has_one_attached :shop_image

  validates :shop_image,
            content_type: %i(png jpg jpeg),                        # 画像の種類
            size: { less_than_or_equal_to: 5.megabytes },              # ファイルサイズ
            dimension: { width: { max: 2000 }, height: { max: 2000 } } # 画像の大きさ

  geocoded_by :full_address

  def image_as_thumbnail
    return unless shop_image.content_type.in?(%w[image/jpeg image/png])

    shop_image.variant(resize_to_limit: [400, 500])
  end

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
