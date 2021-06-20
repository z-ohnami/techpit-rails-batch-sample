namespace :ranks do
  namespace :chapter3 do
    desc 'chapter3 ゲーム内のユーザーランキング情報を更新する'
    task update: :environment do
      Development::UsedMemoryReport.instance.write('start batch')
      Benchmark.bm 10 do |r|
        r.report 'RankUpdator' do
          RanksUpdater.new.update_all
        end
      end

      Development::UsedMemoryReport.instance.write('end batch')
      Development::UsedMemoryReport.instance.puts_all
    end
  end
end
