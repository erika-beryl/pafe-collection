class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parfait

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 500 }

end
