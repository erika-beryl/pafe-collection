FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    name { "testuser" }
    password { "password" }
    password_confirmation { "password" }

    trait :with_avatar do
      after(:build) do |user|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        user.avatar.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'image/png'),
          filename: File.basename(noimage_path)
        )
      end
    end

    trait :invalid_avatar do
      after(:build) do |user|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'dummy.txt')
        user.avatar.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'text/plain'),
          filename: File.basename(noimage_path)
        )
      end
    end
  end
end
