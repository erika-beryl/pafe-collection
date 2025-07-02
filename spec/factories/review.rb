FactoryBot.define do
  factory :review do
    association :parfait
    association :user

    title { "テストレビュー" }
    body { "美味しかった" }

    trait :with_review_image do
      after(:build) do |review|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        noimage_file = File.open(noimage_path)
        review.review_images.attach(
          io: noimage_file,
          filename: File.basename(noimage_path),
          content_type: 'image/png'
        )
      end
    end

    trait :invalid_review_image do
      after(:build) do |review|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        noimage_file = File.open(noimage_path)
        review.review_images.attach(
          io: noimage_file,
          filename: File.basename(noimage_path),
          content_type: 'application/pdf'
        )
      end
    end
  end
end