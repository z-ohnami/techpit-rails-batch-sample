require 'rails_helper'

RSpec.describe DailyRanksUpdator, type: :model do
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
          create(:user_score, user: user1, score: 2, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user1, score: 1, received_at: '2020-08-10 10:00:00')

          DailyRanksUpdator.call
        end

        it 'ranksテーブルにデータが作成される' do
          expect(DailyRank.count).to eq 1

          rank = DailyRank.first
          expect(rank.rank).to eq 1
          expect(rank.score).to eq 6
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

          DailyRanksUpdator.call
        end

        it 'monthly_ranksテーブルにデータが作成される' do
          expect(DailyRank.count).to eq 3

          ranks = DailyRank.all.order(:rank)
          expect(ranks[0].user_id).to eq user2.id
          expect(ranks[0].rank).to eq 1
          expect(ranks[0].score).to eq 17

          expect(ranks[1].user_id).to eq user1.id
          expect(ranks[1].rank).to eq 2
          expect(ranks[1].score).to eq 6

          expect(ranks[2].user_id).to eq user3.id
          expect(ranks[2].rank).to eq 3
          expect(ranks[2].score).to eq 3
        end
      end

      context 'スコア所持ユーザーがいるが、期間外のスコアのみの場合' do
        before do
          create(:user_score, user: user1, score: 3, received_at: '2020-08-09 10:00:00')
          create(:user_score, user: user1, score: 2, received_at: '2020-08-09 10:00:00')
          create(:user_score, user: user1, score: 1, received_at: '2020-08-09 10:00:00')

          create(:user_score, user: user2, score: 10, received_at: '2020-08-08 10:00:00')
          create(:user_score, user: user2, score: 3, received_at: '2020-08-08 10:00:00')
          create(:user_score, user: user2, score: 4, received_at: '2020-08-08 10:00:00')

          create(:user_score, user: user3, score: 1, received_at: '2019-08-10 10:00:00')
          create(:user_score, user: user3, score: 1, received_at: '2019-08-10 10:00:00')
          create(:user_score, user: user3, score: 1, received_at: '2019-08-10 10:00:00')

          DailyRanksUpdator.call
        end

        it 'daily_ranksテーブルは空である' do
          expect(DailyRank.count).to eq 0
        end
      end

      context 'スコア所持ユーザーが誰もいない場合' do
        before do
          create(:user)
          create(:user)
          create(:user)

          DailyRanksUpdator.call
        end

        it 'monthly_ranksテーブルは空である' do
          expect(DailyRank.count).to eq 0
        end
      end

      context 'ユーザーが存在しない場合' do
        before do
          DailyRanksUpdator.call
        end

        it 'monthly_ranksテーブルは空である' do
          expect(DailyRank.count).to eq 0
        end
      end
    end

    # 既存のランキング情報がまだ存在していない場合
    include_examples 'ランキング情報更新処理の検証'

    context '過去のランキング情報が残っている場合' do
      before do
        create(:daily_rank, user: user1, rank: 3, score: 10)
        create(:daily_rank, user: user2, rank: 2, score: 20)
        create(:daily_rank, user: user3, rank: 1, score: 31)
      end

      include_examples 'ランキング情報更新処理の検証'
    end
  end
end
