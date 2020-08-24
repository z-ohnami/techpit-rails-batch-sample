FactoryBot.define do
  factory :rank do
    association :user
    rank { 1 }
    score { 1 }
  end
end
