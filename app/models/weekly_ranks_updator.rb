class WeeklyRanksUpdator
  class << self
    def call
      new.call
    end
  end

  def call
    # テーブルの情報をリセット
    WeeklyRank.delete_all

    User.includes(:user_scores).find_in_batches do |users|
      WeeklyRank.import users.select(&:weekly_score_hold?).map { |user| { user_id: user.id, score: user.weekly_total_score }  }
    end

    Chapter5::RankOrderMaker.new(WeeklyRank).call do |score, rank|
      WeeklyRank.where(score: score).update(rank: rank)
    end
  end
end
