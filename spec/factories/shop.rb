FactoryBot.define do
  factory :shop do
    name { "testshop" }
    postal_code { "1111111" }
    prefecture_code { 13 }
    city { "テスト区" }
    street { "テスト1-2-3" }
    tel { "0312345678" }
    reservation { true }
    parking { false }
  end
end