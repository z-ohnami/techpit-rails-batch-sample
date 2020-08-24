module Chapter3Refactoring
  class RankOrderMaker
    def call
      Rank.distinct(:score).order(score: :desc).pluck(:score).each.with_index(1) do |score, index|
        yield(score, index)
      end
    end
  end
end
