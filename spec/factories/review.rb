FactoryBot.define do
  factory :review do
    association :parfait
    association :user

    title { "テストレビュー" }
    body { "美味しかった" }

    trait :with_review_image do
      after(:build) do |review|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        review.review_images.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'image/png'),
          filename: File.basename(noimage_path)
        )
      end
    end

    trait :invalid_review_image do
      after(:build) do |review|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'dummy.txt')
        review.review_images.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'text/plain'),
          filename: File.basename(noimage_path)
        )
      end
    end
  end
end
