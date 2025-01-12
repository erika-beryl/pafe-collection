class ShopMustForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include JpPrefecture
  jp_prefecture :prefecture_code

  attr_accessor :name, :postal_code, :prefecture_code, :city, :street, :other_address, :tel, :is_open, :weekly, :open_time, :close_time, :opentimes 

  validates :name, presence: true
  validates :postal_code, presence: true
  validates :prefecture_code, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true

  def initialize(attributes = {})
    super
    @opentimes ||= [] # ここで初期化しておく
  end

  # Opentimeのenum weeklyを取得するメソッド
  def self.weekly_options
    Opentime.weeklies.keys.map { |day| [day.humanize, day] }
  end


  def save

    ActiveRecord::Base.transaction do
      shop = Shop.new(name: name, postal_code: postal_code, prefecture_code: prefecture_code, 
                          city: city, street: street, other_address: other_address, tel: tel)
      shop.full_address = generate_address(shop)
                          
      opentimes.each do |opentime|
        new_opentime = Opentimes.create(is_open: opentime[:is_open], weekly: opentime[:weekly], 
                                        open_time: opentime[:open_time], close_time: opentime[:close_time])
        shop.opentimses << new_opentime
      end

      shop.save
    end

  end


  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  private

  def generate_address(shop)
    # buildingが空の場合は除外してaddressを生成
    [prefecture_name, city, street, other_address.presence].compact.join(" ")
  end


end