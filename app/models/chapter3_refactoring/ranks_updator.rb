module Chapter3Refactoring
  class RanksUpdator
    class << self
      def call
        new.call
      end
    end

    def call
      # 現在のランキング情報をリセット
      Rank.delete_all

      # ユーザーごとのスコア合計を降順に並べ替え、そこからランキング情報を再作成する
      build_ranks
      assign_ranks
    end

    private

    def build_ranks
      User.includes(:user_scores).find_in_batches do |users|
        Rank.import users.select(&:score_hold?).map { |user| { user_id: user.id, score: user.total_score }  }
      end
    end

    def assign_ranks
      Chapter3Refactoring::RankOrderMaker.new.call do |score, rank|
        Rank.where(score: score).update(rank: rank)
      end
    end
  end
end
