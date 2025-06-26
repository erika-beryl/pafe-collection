class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  before_create :set_provider_uid_for_email_user
  
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_reviews, through: :bookmarks, source: :review

  has_one_attached :avatar

  validates :name, presence: true
  validates :uid, uniqueness: { scope: :provider }

  validates :avatar,
            content_type: %i(png jpg jpeg),
            size: { less_than_or_equal_to: 10.megabytes },
            dimension: { width: { max: 4100 }, height: { max: 4100 } }


  def own?(object)
    id == object&.user_id
  end

  def set_provider_uid_for_email_user
    if provider.blank? && uid.blank?
      Rails.logger.info "=== set_provider_uid_for_email_user called ==="
      self.provider = 'default'
      self.uid = SecureRandom.uuid
    end
  end
    
  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user
      user.update(provider: auth.provider, uid: auth.uid)
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

  def bookmark(review)
    bookmark_reviews << review
  end

  def unbookmark(review)
    bookmark_reviews.destroy(review)
  end

  def bookmark?(review)
    bookmark_reviews.include?(review)
  end
end
