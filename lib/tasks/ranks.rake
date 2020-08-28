require 'benchmark'
require 'objspace'

namespace :ranks do
  namespace :chapter2 do
    desc 'chapter2 ゲーム内のユーザーランキング情報を更新する'
    task update: :environment do
      # 現在のランキング情報をリセット
      Rank.all(&:destroy)

      # ユーザーごとに当月のスコア合計を計算する
      user_total_scores = User.all.map do |user|
        { user_id: user.id, total_score: user.user_scores.sum(&:score) }
      end

      # ユーザーごとのスコア合計の降順に並べ替え、そこからランキング情報を再作成する
      user_total_scores.sort_by { |score| score[:total_score] * -1 }.each.with_index(1) do |total_score, index|
        Rank.create(user_id: total_score[:user_id], rank: index, score: total_score[:total_score])
      end
    end
  end

  namespace :chapter3 do
    desc 'chapter3 ゲーム内のユーザーランキング情報を更新する'
    task update: :environment do
      Benchmark.bm 10 do |r|
        r.report 'RankUpdator' do
          RanksUpdator.call
        end
      end

      puts "memsize_of_all #{ObjectSpace.memsize_of_all * 0.001 * 0.001} MB"
    end
  end

  namespace :chapter3_refactoring do
    desc 'chapter3 refactoring ゲーム内のユーザーランキング情報を更新する'
    task update: :environment do
      Benchmark.bm 10 do |r|
        r.report 'RankUpdator' do
          Chapter3Refactoring::RanksUpdator.call
        end
      end

      puts "memsize_of_all #{ObjectSpace.memsize_of_all * 0.001 * 0.001} MB"
    end
  end

  namespace :chapter5 do
    desc 'chapter5 ゲーム内のユーザーランキング情報を更新する'
    task update: :environment do
      Benchmark.bm 10 do |r|
        r.report 'RankUpdator' do
          Chapter5::RanksUpdator.call
        end
      end

      puts "memsize_of_all #{ObjectSpace.memsize_of_all * 0.001 * 0.001} MB"
    end
  end
end
