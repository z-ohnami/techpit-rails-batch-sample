class DailyRanksUpdator
  class << self
    def call
      new.call
    end
  end

  def call
    # テーブルの情報をリセット
    DailyRank.delete_all

    User.includes(:user_scores).find_in_batches do |users|
      DailyRank.import users.select(&:daily_score_hold?).map { |user| { user_id: user.id, score: user.daily_total_score }  }
    end

    Chapter5::RankOrderMaker.new(DailyRank).call do |score, rank|
      DailyRank.where(score: score).update(rank: rank)
    end
  end
end
