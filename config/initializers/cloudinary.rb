if ENV['CLOUDINARY_URL'].present?
  Cloudinary.config do |config|
    config.enhance_image_tag = true
    config.static_file_support = false
  end
end

# cloudinaryで拡張機能を有効にするファイル。heroku環境ではconfig/cloudinary.ymlだと反映されないことがある。