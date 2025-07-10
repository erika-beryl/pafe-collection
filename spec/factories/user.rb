FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    name { "testuser" }
    password { "password" }
    password_confirmation { "password" }

    trait :with_avatar do
      after(:build) do |user|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        noimage_file = File.open(noimage_path)
        user.avatar.attach(
          io: noimage_file,
          filename: File.basename(noimage_path),
          content_type: 'image/png'
        )
      end
    end

    trait :invalid_avatar do
      after(:build) do |user|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'dummy.txt')
        noimage_file = File.open(noimage_path)
        user.avatar.attach(
          io: noimage_file,
          filename: File.basename(noimage_path),
          content_type: 'text/plain'
        )
      end
    end
  end
end
