FactoryBot.define do
  factory :parfait do
    association :shop

    name { "テストパフェ" }
    body { "美味しいパフェです" }
    price { 2 }
    trait :with_parfait_image do
      after(:build) do |parfait|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        parfait.parfait_image.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'image/png'),
          filename: File.basename(noimage_path)
        )
      end
    end

    trait :invalid_parfait_image do
      after(:build) do |parfait|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'dummy.txt')
        parfait.parfait_image.attach(
          io: Rack::Test::UploadedFile.new(noimage_path, 'text/plain'),
          filename: File.basename(noimage_path)
        )
      end
    end
  end
end
