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
    return if invalid?
    full_address = generate_address
    ActiveRecord::Base.transaction do
      shop.update!(name: name, postal_code: postal_code, prefecture_code: prefecture_code, 
                    city: city, street: street, other_address: other_address, tel: tel, reservation: reservation, parking: parking, full_address: full_address,
                    feature_ids: feature_ids.reject(&:blank?), payment_ids: payment_ids.reject(&:blank?))     
      if shop.business
        shop.business.update!(business_time: business_time)
      else
        shop.create_business!(business_time: business_time)
      end

      if remove_shop_image == '1'
        if shop.shop_image.attached?
          # 本番環境ならCloudinaryの画像も削除する
          if Rails.env.production?
            begin
              # ActiveStorageのメタ情報からCloudinaryのpublic_idを取得
              key = shop.shop_image.key # ActiveStorageで保存されているkey
              Cloudinary::Uploader.destroy(key) # Cloudinary上の画像を削除
            rescue => e
              Rails.logger.warn "Cloudinary削除失敗: #{e.message}"
            end
          end
      
          # ActiveStorageのデータ削除（Cloudinaryも含めて削除済みの場合も含む）
          shop.shop_image.purge
        end
      
        # インスタンス変数の画像もクリア
        self.shop_image = nil
      end
      
      # 新しい画像を保存する処理
      if shop_image.present?
        if Rails.env.production?
          begin
            uploaded = Cloudinary::Uploader.upload(shop_image, transformation: { height: 1350, crop: :limit, format: 'jpg', quality: 'auto' })
            Rails.logger.info "Cloudinary upload successful: #{uploaded['secure_url']}"
            
            # Cloudinaryのpublic_idをActiveStorageのkeyとして設定
            shop.shop_image.purge if shop.persisted? && shop.shop_image.attached?
        
            # ActiveStorageのkeyをCloudinaryのpublic_idに設定
            shop.shop_image.attach(
              io: URI.open(uploaded['secure_url']), # CloudinaryのURLを取得
              filename: "#{File.basename(shop_image.original_filename, '.*')}.jpg", 
              content_type: 'image/jpg',
            )
            
            shop.shop_image.key = uploaded['public_id']
          rescue CloudinaryException => e
            Rails.logger.error "Cloudinary upload failed: #{e.message}"
            raise "Cloudinary upload failed: #{e.message}" # エラーを投げてトランザクションをロールバック
          end
        else
          # 開発・テスト環境（ローカルストレージにそのまま保存）
          shop.shop_image.purge if shop.persisted? && shop.shop_image.attached?
          shop.shop_image.attach(shop_image)
        end
      end
        
    end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to save shop: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
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
  
end