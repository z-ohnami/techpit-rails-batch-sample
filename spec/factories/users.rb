FactoryBot.define do
  factory :user do
    # name { 'テストボーイ' }
    sequence(:name) { |n| "ゲームユーザー#{n}" }
  end
end
