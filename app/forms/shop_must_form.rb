class ShopMustForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include JpPrefecture
  jp_prefecture :prefecture_code

  attr_accessor :name, :postal_code, :prefecture_code, :city, :street, :other_address, :tel, :reservation, :parking

  validates :name, presence: true
  validates :postal_code, presence: true
  validates :prefecture_code, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true

  delegate :persisted?, to: :shop

  def initialize(attributes = nil, shop: Shop.new)
    @shop = shop
    attributes ||= default_attributes
    super(attributes)
  end

  # アクションのURLを適切な場所に切り替え
  def to_model
    shop
  end

  def save

    self.reservation = reservation == "1"
    self.parking = parking == "1"
    return if invalid?
    full_address = generate_address
    ActiveRecord::Base.transaction do
      shop.update!(name: name, postal_code: postal_code, prefecture_code: prefecture_code, 
                    city: city, street: street, other_address: other_address, tel: tel, reservation: reservation, parking: parking, full_address: full_address)
    end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to save shop: #{e.message}")
      false
  end


  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  private

  attr_reader :shop

  def default_attributes
    {
      name: shop.name,
      postal_code: shop.postal_code,
      prefecture_code: shop.prefecture_code,
      city: shop.city,
      street: shop.street,
      other_address: shop.other_address,
      tel: shop.tel,
      reservation: shop.reservation,
      parking: shop.parking
    }
  end

  def generate_address
    # buildingが空の場合は除外してaddressを生成
    [prefecture_name, city, street, other_address.presence].compact.join(" ")
  end


end