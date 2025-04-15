class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parfait

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }

  has_many_attached :review_images
  validates :review_images,
            content_type: %i(gif png jpg jpeg),                        # 画像の種類
            size: { less_than_or_equal_to: 5.megabytes },              # ファイルサイズ
            dimension: { width: { max: 2000 }, height: { max: 2000 } } # 画像の大きさ


  def image_as_thumbnail
    return unless review_images.content_type.in?(%w[image/jpeg image/png])
    review_images.variant(resize_to_limit: [400, 500]).processed
  end

end
