class MonthlyRanksUpdator
  class << self
    def call
      new.call
    end
  end

  def call
    # テーブルの情報をリセット
    MonthlyRank.delete_all

    User.includes(:user_scores).find_in_batches do |users|
      MonthlyRank.import users.select(&:monthly_score_hold?).map { |user| { user_id: user.id, score: user.monthly_total_score }  }
    end

    Chapter5::RankOrderMaker.new(MonthlyRank).call do |score, rank|
      MonthlyRank.where(score: score).update(rank: rank)
    end
  end
end
