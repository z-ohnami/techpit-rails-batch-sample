require 'rails_helper'

RSpec.describe Chapter5::RanksUpdator, type: :model do
  let(:current_time) { '2020-08-11 10:00:00' }
  around do |e|
    travel_to(current_time) { e.run }
  end

  describe '.call' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

    shared_examples 'ランキング情報更新処理の検証' do
      context 'スコア所持ユーザーが1名いる場合' do
        before do
          create(:user_score, user: user1, score: 3, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user1, score: 2, received_at: '2020-08-01 10:00:00')
          create(:user_score, user: user1, score: 1, received_at: '2020-08-02 10:00:00')

          Chapter5::RanksUpdator.call
        end

        it '各ranksテーブルにデータが作成される' do
          expect(MonthlyRank.count).to eq 1

          monthly_rank = MonthlyRank.first
          expect(monthly_rank.rank).to eq 1
          expect(monthly_rank.score).to eq 6

          expect(WeeklyRank.count).to eq 1

          weekly_rank = WeeklyRank.first
          expect(weekly_rank.rank).to eq 1
          expect(weekly_rank.score).to eq 3

          expect(DailyRank.count).to eq 1

          daily_rank = DailyRank.first
          expect(daily_rank.rank).to eq 1
          expect(daily_rank.score).to eq 3
        end
      end

      context 'スコア所持ユーザーが複数いる場合' do
        before do
          create(:user_score, user: user1, score: 3, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user1, score: 2, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user1, score: 1, received_at: '2020-08-10 10:00:00')

          create(:user_score, user: user2, score: 10, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user2, score: 3, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user2, score: 4, received_at: '2020-08-10 10:00:00')

          create(:user_score, user: user3, score: 1, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user3, score: 1, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user3, score: 1, received_at: '2020-08-10 10:00:00')

          Chapter5::RanksUpdator.call
        end

        it 'monthly_ranksテーブルにデータが作成される' do
          expect(MonthlyRank.count).to eq 3

          monthly_ranks = MonthlyRank.all.order(:rank)
          expect(monthly_ranks[0].user_id).to eq user2.id
          expect(monthly_ranks[0].rank).to eq 1
          expect(monthly_ranks[0].score).to eq 17

          expect(monthly_ranks[1].user_id).to eq user1.id
          expect(monthly_ranks[1].rank).to eq 2
          expect(monthly_ranks[1].score).to eq 6

          expect(monthly_ranks[2].user_id).to eq user3.id
          expect(monthly_ranks[2].rank).to eq 3
          expect(monthly_ranks[2].score).to eq 3
        end

        it 'weekly_ranksテーブルにデータが作成される' do
          expect(WeeklyRank.count).to eq 3

          weekly_ranks = WeeklyRank.all.order(:rank)
          expect(weekly_ranks[0].user_id).to eq user2.id
          expect(weekly_ranks[0].rank).to eq 1
          expect(weekly_ranks[0].score).to eq 17

          expect(weekly_ranks[1].user_id).to eq user1.id
          expect(weekly_ranks[1].rank).to eq 2
          expect(weekly_ranks[1].score).to eq 6

          expect(weekly_ranks[2].user_id).to eq user3.id
          expect(weekly_ranks[2].rank).to eq 3
          expect(weekly_ranks[2].score).to eq 3
        end

        it 'weekly_ranksテーブルにデータが作成される' do
          expect(DailyRank.count).to eq 3

          daily_ranks = DailyRank.all.order(:rank)
          expect(daily_ranks[0].user_id).to eq user2.id
          expect(daily_ranks[0].rank).to eq 1
          expect(daily_ranks[0].score).to eq 17

          expect(daily_ranks[1].user_id).to eq user1.id
          expect(daily_ranks[1].rank).to eq 2
          expect(daily_ranks[1].score).to eq 6

          expect(daily_ranks[2].user_id).to eq user3.id
          expect(daily_ranks[2].rank).to eq 3
          expect(daily_ranks[2].score).to eq 3
        end
      end

      context 'スコア所持ユーザーが誰もいない場合' do
        before do
          create(:user)
          create(:user)
          create(:user)

          Chapter5::RanksUpdator.call
        end

        it '各ranksテーブルは空である' do
          expect(MonthlyRank.count).to eq 0
          expect(WeeklyRank.count).to eq 0
          expect(DailyRank.count).to eq 0
        end
      end

      context 'ユーザーが存在しない場合' do
        before do
          Chapter5::RanksUpdator.call
        end

        it '各ranksテーブルは空である' do
          expect(MonthlyRank.count).to eq 0
          expect(WeeklyRank.count).to eq 0
          expect(DailyRank.count).to eq 0
        end
      end
    end

    # 既存のランキング情報がまだ存在していない場合
    include_examples 'ランキング情報更新処理の検証'

    context '過去のランキング情報が残っている場合' do
      before do
        create(:monthly_rank, user: user1, rank: 3, score: 10)
        create(:monthly_rank, user: user2, rank: 2, score: 20)
        create(:monthly_rank, user: user3, rank: 1, score: 31)
      end

      include_examples 'ランキング情報更新処理の検証'
    end
  end
end
