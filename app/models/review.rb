class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parfait

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }

  has_many_attached :review_images
  validates :review_images,
            content_type: { in: %i(png jpg jpeg),
            message: "有効なフォーマットではありません" },
            size: { less_than_or_equal_to: 10.megabytes, message: "10MBを超える画像はアップロードできません" },              # ファイルサイズ
            dimension: { width: { max: 4000 }, height: { max: 4100 } } # 画像の大きさ

  validate :limit_review_images_count

  def image_as_thumbnail
    return unless review_images.content_type.in?(%w[image/jpeg image/png])
    review_images.variant(resize_to_limit: [400, 500]).processed
  end

  private
  def limit_review_images_count
    if review_images.attached? && review_images.length > 3
      errors.add(:review_images, "は3枚までしかアップロードできません")
    end
  end

end
