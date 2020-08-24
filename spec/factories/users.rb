FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "ゲームユーザー#{n}" }
  end
end
