FactoryBot.define do
  factory :monthly_rank do
    association :user
    rank { 1 }
    score { 1 }
    sequence(:score_title) { |n| "素敵な称号#{n}" }
  end
end
