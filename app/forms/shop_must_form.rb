require 'open-uri'

class ShopMustForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include JpPrefecture
  jp_prefecture :prefecture_code

  attr_accessor :name, :postal_code, :prefecture_code, :city, :street, :other_address, :tel, :reservation, :parking,
                :shop_image, :remove_shop_image, :business_time, :payment_ids, :feature_ids

  validates :name, presence: true
  validates :postal_code, presence: true
  validates :prefecture_code, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true
  validate :name_unique

  validates :postal_code,
          presence: true,
          format: { with: /\A\d{7}\z/, message: "は7桁の半角数字で入力してください" }


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
    # チェックボックスでオンの時1で送られるので、=="1"でtrueに変換してる。
    self.reservation = reservation == "1"
    self.parking = parking == "1"
    return false if invalid?
    full_address = generate_address

    address_changed = full_address != shop.full_address

    if address_changed
      shop.assign_attributes(full_address: full_address)
      shop.geocode
    end

    ActiveRecord::Base.transaction do
      shop.update!(name: name, postal_code: postal_code, prefecture_code: prefecture_code, 
                    city: city, street: street, other_address: other_address, tel: tel, reservation: reservation, parking: parking, full_address: full_address,
                    latitude: address_changed ? shop.latitude : shop.latitude_was, longitude: address_changed ? shop.longitude : shop.longitude_was,
                    feature_ids: feature_ids.reject(&:blank?), payment_ids: payment_ids.reject(&:blank?))     
      if shop.business
        shop.business.update!(business_time: business_time)
      else
        shop.create_business!(business_time: business_time)
      end

      if remove_shop_image == '1'
        if shop.shop_image.attached?
          shop.shop_image.purge
        end 
        # インスタンス変数の画像もクリア
        self.shop_image = nil
      end

      
      # 新しい画像を保存する処理。shopモデルの方でアタッチする。
      if shop_image.present?
        shop.shop_image.purge if shop.shop_image.attached?
        shop.shop_image.attach(shop_image)
      end
        
    end

    # フォームオブジェクトなのでtrueを明文化しないと最後の処理がnilかtrueかで変わってしまう。画像は任意にしたのでこうしないといけない。
    true
  rescue ActiveRecord::RecordInvalid => e
    false
  end


  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code)&.name
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
      parking: shop.parking,
      feature_ids: shop.feature_ids,
      payment_ids: shop.payment_ids,
      business_time: shop.business.present? ? shop.business.business_time : nil,
      shop_image: shop.shop_image
    }
  end

  def generate_address
    # buildingが空の場合は除外してaddressを生成
    [prefecture_name, city, street, other_address.presence].compact.join(" ")
  end

  def split_shop_business_hours
    shop_business_hours.split("\n")
  end

  def name_unique
    same_shop = Shop.find_by(name: name)
    if same_shop && same_shop.id != shop.id
      errors.add(:name, "はすでに使われています")
    end
  end
end