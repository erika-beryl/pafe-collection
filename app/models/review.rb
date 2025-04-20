class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parfait

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }

  has_many_attached :review_images
  validate :review_images_limit
  validates :review_images,
            content_type: { in: %i(png jpg jpeg),
            message: "有効なフォーマットではありません" },
            size: { less_than_or_equal_to: 10.megabytes, message: "5MBを超える画像はアップロードできません" },              # ファイルサイズ
            dimension: { width: { max: 2000 }, height: { max: 2000 } } # 画像の大きさ


  def image_as_thumbnail
    return unless review_images.content_type.in?(%w[image/jpeg image/png])
    review_images.variant(resize_to_limit: [400, 500]).processed
  end

  def review_images_limit
    if review_images.attached? && review_images.count > 5
      errors.add(:review_images, "は5枚までアップロードできます")
    end
  end

end
