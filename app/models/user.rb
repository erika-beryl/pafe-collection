class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :reviews, dependent: :destroy

  has_one_attached :avatar

  validates :avatar,
            content_type: %i(png jpg jpeg),                        # 画像の種類
            size: { less_than_or_equal_to: 10.megabytes },              # ファイルサイズ
            dimension: { width: { max: 4100 }, height: { max: 4100 } } # 画像の大きさ


  def own?(object)
    id == object&.user_id
  end
end
