class RanksUpdater
  class << self
    def call
      new.call
    end
  end

  def call
    # 現在のランキング情報をリセット
    Rank.delete_all

    # ユーザーごとのスコア合計を降順に並べ替え、そこからランキング情報を再作成する
    create_ranks
  end

  private

  def create_ranks
    RankOrderMaker.new.call do |user, index|
      Rank.create(user_id: user.id, rank: index, score: user.total_score)
    end
  end
end
