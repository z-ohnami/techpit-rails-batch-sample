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
      api_response = score_title_fetcher.call(score)
      raise ActiveRecord::Rollback if api_response[:status] != 200

      MonthlyRank.where(score: score).update(rank: rank, score_title: api_response[:title])
    end
  end

  private

  def score_title_fetcher
    @score_title_fetcher ||= ScoreTitleFetcher.new
  end
end
