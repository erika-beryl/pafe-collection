FactoryBot.define do
  factory :parfait do
    association :shop

    name { "テストパフェ" }
    body { "美味しいパフェです" }
    price { 2 }
    trait :with_parfait_image do
      after(:build) do |parfait|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        noimage_file = File.open(noimage_path)
        parfait.parfait_image.attach(
          io: noimage_file,
          filename: File.basename(noimage_path),
          content_type: 'image/png'
        )
      end
    end

    trait :invalid_parfait_image do
      after(:build) do |parfait|
        noimage_path = Rails.root.join('spec', 'fixtures', 'images', 'noimage.png')
        noimage_file = File.open(noimage_path)
        parfait.parfait_image.attach(
          io: noimage_file,
          filename: File.basename(noimage_path),
          content_type: 'application/pdf'
        )
      end
    end
  end
end
