FactoryBot.define do
  factory :daily_rank do
    association :user
    rank { 1 }
    score { 1 }
  end
end
