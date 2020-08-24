class RanksUpdator
  class << self
    def call
      new.call
    end
  end

  def call
    # 現在のランキング情報をリセット
    Rank.all.each(&:destroy)

    # ユーザーごとのスコア合計を降順に並べ替え、そこからランキング情報を再作成する
    build_ranks
  end

  private

  def build_ranks
    RankOrderMaker.new.call do |user, index|
      Rank.create(user_id: user.id, rank: index, score: user.total_score)
    end
  end
end
