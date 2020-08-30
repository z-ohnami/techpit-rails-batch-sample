module Chapter5
  class RanksUpdator
    class << self
      def call
        new.call
      end
    end

    def call
      ActiveRecord::Base.transaction do
        # 月間ランキング情報の更新
        MonthlyRanksUpdator.call

        # 週間ランキング情報の更新
        WeeklyRanksUpdator.call

        # 日次(昨日時点)ランキング情報の更新
        DailyRanksUpdator.call

      rescue => e
        # バッチが失敗した場合の後処理を書く。チャットや監視サービスへ通知するなど運用に応じて。
        # puts "batch faild #{e.message}"
        raise e
      end
    end
  end
end
