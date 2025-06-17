class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
  
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_reviews, through: :bookmarks, source: :review

  has_one_attached :avatar

  validates :uid, uniqueness: { scope: :provider }

  validates :avatar,
            content_type: %i(png jpg jpeg),                        # 画像の種類
            size: { less_than_or_equal_to: 10.megabytes },              # ファイルサイズ
            dimension: { width: { max: 4100 }, height: { max: 4100 } } # 画像の大きさ


  def own?(object)
    id == object&.user_id
  end

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user
      user.update(provider: auth.provider, uid: auth.uid) unless user.provider.present? && user.uid.present?
      return user
    else
      User.create!(
        email: auth.info.email,
        name: auth.info.name,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        uid: auth.uid
      )
    end
  end
end
