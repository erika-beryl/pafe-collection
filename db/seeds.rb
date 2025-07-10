# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
if Rails.env.development? || Rails.env.test?
  # 開発環境用：全てのmethod_typesとtraitsを挿入
  traits = %w[景色がよい ファミリー向け カウンター席有り 大食いチャレンジ有り 貸切可]
  traits.each do |trait_name|
    Feature.find_or_create_by(trait: trait_name)
  end

  method_types = %w[カード可 カード不可 電子マネー可 電子マネー不可 QRコード決済可 QRコード決済不可]
  method_types.each do |method_name|
    Payment.find_or_create_by(method_type: method_name)
  end

elsif Rails.env.production?
  traits = %w[景色がよい ファミリー向け カウンター席有り 大食いチャレンジ有り 貸切可]
  traits.each do |trait_name|
    Feature.find_or_create_by(trait: trait_name)
  end

  method_types = %w[カード可 電子マネー可 QRコード決済可 ]
  method_types.each do |method_name|
    Payment.find_or_create_by(method_type: method_name)
  end

end

