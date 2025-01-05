class Feature < ApplicationRecord
  has_many :shop_features
  has_many :features, through: :shop_features
end
