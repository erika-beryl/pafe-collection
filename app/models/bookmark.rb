class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, uniqueness: { scope: :review_id }
  validate :cannot_bookmark_self

  def cannot_bookmark_self
    if user_id == review&.user_id
      errors.add(:user_id, "自分のレビューにはブックマークできません")
    end
  end

end
