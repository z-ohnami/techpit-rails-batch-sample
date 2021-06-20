module Chapter5Part5
  class RanksUpdater
    def update_all
      Rank.transaction do
        # 現在のランキング情報をリセット
        Rank.delete_all
        Development::UsedMemoryReport.instance.write('after Rank.delete_all')

        # ユーザーごとのスコア合計を降順に並べ替え、そこからランキング情報を再作成する
        create_ranks
        Development::UsedMemoryReport.instance.write('after create_ranks')
        update_ranks
        Development::UsedMemoryReport.instance.write('after update_ranks')
      end
    end

    private

    def create_ranks
      User.includes(:user_scores).find_in_batches(batch_size: 100) do |users|
        Rank.import users
                      .select(&:score_hold?)
                      .map { |user| { user_id: user.id, score: user.total_score } }
      end
    end

    def update_ranks
      RankOrderMaker.new.each_ranked_user do |score, rank|
        Rank.where(score: score).update_all(rank: rank)
      end
    end
  end
end
