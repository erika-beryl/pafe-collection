class ShopMustForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :postal_code, :string
  attribute :prefecture, :string
  attribute :city, :string
  attribute :street, :string
  attribute :other_address, :string
  attribute :tel
  attribute :is_open, :boolean
  attribute :weekly, :integer
  attribute :open_time, :time
  attribute :close_time, :time

  validates :name, presence: true, uniqueness: true
  validates :postal_code, presence: true
  validates :prefecture, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :tel, presence: true, uniqueness: true


  def initialize(attributes = nil, shop: Shop.new)
    @shop = shop
    7.times { @shop.opentimes.build }
  end

  def save
    return if invalid?

    generate_address

    ActiveRecord::Base.transaction do
      @shop.save!
      @shop.opentimes.each(&:save!)
    end
  end



  private

  def generate_address
    # buildingが空の場合は除外してaddressを生成
    @shop.full_address = [prefecture, city, street, other_address.presence].compact.join(" ")
  end

end