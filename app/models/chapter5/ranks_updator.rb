module Chapter5
  class RanksUpdator
    class << self
      def call
        new.call
      end
    end

    def call
      ActiveRecord::Base.transaction do
        MonthlyRanksUpdator.call
        WeeklyRanksUpdator.call
        DailyRanksUpdator.call

      rescue => e
        # バッチが失敗した場合の後処理を書く。チャットや監視サービスへ通知するなど運用に応じて。
        puts "batch faild #{e.message}"
        raise e
      end
    end
  end
end
