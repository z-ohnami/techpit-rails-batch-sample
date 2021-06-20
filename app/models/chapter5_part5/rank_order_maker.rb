module Chapter5Part5
  class RankOrderMaker
    def each_ranked_user
      Rank
        .distinct(:score)
        .order(score: :desc)
        .pluck(:score)
        .each
        .with_index(1) do |score, index|
        yield(score, index)
      end
    end
  end
end
