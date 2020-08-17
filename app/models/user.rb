class User < ApplicationRecord
  has_many :user_scores
  has_one :rank
end
