class ShopMustForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include JpPrefecture
  jp_prefecture :prefecture_code

  attribute :name, :string
  attribute :postal_code, :string
  attribute :prefecture_code, :integer
  attribute :city, :string
  attribute :street, :string
  attribute :other_address, :string
  attribute :tel
  attribute :is_open, :boolean
  attribute :weekly, :integer
  attribute :open_time, :time
  attribute :close_time, :time

  validates :name, presence: true
  validates :postal_code, presence: true
  validates :prefecture_code, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true


  def initialize(attributes = nil, shop: Shop.new)
    @shop = shop
    7.times { @shop.opentimes.build } if @shop.opentimes.empty?
    super(attributes)
  end

  def save
    return if invalid?

    generate_address

    ActiveRecord::Base.transaction do
      @shop.save!
      @shop.opentimes.each(&:save!)
    end
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
    @shop.full_address = [prefecture_name, city, street, other_address.presence].compact.join(" ")
  end

end