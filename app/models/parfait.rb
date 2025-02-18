class Parfait < ApplicationRecord
  belongs_to :shop

  validates :name, presence: true, length: { maximum: 100 }
  validates :body, length: { maximum: 500 }
  validates :price, presence: true

  has_many :reviews, dependent: :destroy
  

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
