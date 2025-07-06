FactoryBot.define do
  factory :bookmark do
    association :review
    association :user
  end
end
