FactoryBot.define do
  factory :weekly_rank do
    association :user
    rank { 1 }
    score { 1 }
  end
end
