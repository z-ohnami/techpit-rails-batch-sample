module Chapter5
  class RankOrderMaker
    def initialize(model_class)
      @model_class = model_class
    end

    def call
      @model_class.distinct(:score).order(score: :desc).pluck(:score).each.with_index(1) do |score, index|
        yield(score, index)
      end
    end
  end
end
