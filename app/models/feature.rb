class Feature < ApplicationRecord
  has_many :shop_features
  has_many :features, through: :shop_features

  enum trait: { カウンター席有り: 0, 個室有り: 1, オープンテラス有り: 2, 落ち着いた空間: 3, オシャレな空間: 4, ソファー席有り: 5, Wi-Fi有り: 6, ペット可: 7, バリアフリー対応: 8 }
end
