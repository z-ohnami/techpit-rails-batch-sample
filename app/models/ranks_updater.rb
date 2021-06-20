class RanksUpdater
  def update_all
    Rank.transaction do
      # 現在のランキング情報をリセット
      Rank.delete_all

      # ユーザーごとのスコア合計を降順に並べ替え、そこからランキング情報を再作成する
      create_ranks
    end
  end

  private

  def create_ranks
    RankOrderMaker.new.each_ranked_user do |user, index|
      Rank.create(user_id: user.id, rank: index, score: user.total_score)
    end
  end
end