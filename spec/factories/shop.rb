FactoryBot.define do
  factory :shop do
    association :user

    sequence(:name) { |n| "testshop#{n}" }
    sequence(:postal_code) { |n| (1000000 + n).to_s }
    prefecture_code { 13 }
    city { "テスト区" }
    street { "テスト1-2-3" }
    sequence(:tel) { |n| "03123456#{format('%02d', n)}" }
    reservation { true }
    parking { false }

    trait :with_shop_image do
      after(:build) do |shop|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        shop.shop_image.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'image/png'),
          filename: File.basename(noimage_path)
        )
      end
    end

    trait :invalid_shop_image do
      after(:build) do |shop|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'dummy.txt')
        shop.shop_image.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'text/plain'),
          filename: File.basename(noimage_path)
        )
      end
    end
  end
end
