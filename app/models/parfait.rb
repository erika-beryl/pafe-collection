class Parfait < ApplicationRecord
  belongs_to :shop

  validates :name, presence: true, length: { maximum: 100 }
  validates :body, length: { maximum: 500 }
  validates :price, presence: true
  has_many :reviews, dependent: :destroy

  has_one_attached :parfait_image

  validates :parfait_image,
            content_type: %i(png jpg jpeg),                        # 画像の種類
            size: { less_than_or_equal_to: 10.megabytes },              # ファイルサイズ
            dimension: { width: { max: 2000 }, height: { max: 2000 } } # 画像の大きさ

  def image_as_thumbnail
    return unless parfait_image.content_type.in?(%w[image/jpeg image/png])

    parfait_image.variant(resize_to_limit: [400, 500]).processed
  end

  attr_accessor :remove_parfait_image

  enum price: {
    under_1000: 0,
    under_1500: 1,
    under_2000: 2,
    under_3000: 3,
    under_4000: 4,
    under_5000: 5,
    under_6000: 6,
    under_7000: 7,
    under_8000: 8,
    under_9000: 9,
    under_10000: 10,
    over_10000: 11
  }

end
