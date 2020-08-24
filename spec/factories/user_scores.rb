FactoryBot.define do
  factory :user_score do
    association :user
    score { 1 }
    received_at { Time.current }
  end
end
