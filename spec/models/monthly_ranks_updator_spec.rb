require 'rails_helper'

RSpec.describe MonthlyRanksUpdator, type: :model do
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

          VCR.use_cassette 'models/monthly_ranks_updator/score_title_user1_200' do
            MonthlyRanksUpdator.call
          end
        end

        it 'ranksテーブルにデータが作成される' do
          expect(MonthlyRank.count).to eq 1

          rank = MonthlyRank.first
          expect(rank.rank).to eq 1
          expect(rank.score).to eq 6
        end
      end

      context 'APIの実行が途中で失敗した場合' do
        before do
          create(:user_score, user: user1, score: 3, received_at: '2020-08-10 10:00:00')
          create(:user_score, user: user1, score: 2, received_at: '2020-08-01 10:00:00')
          create(:user_score, user: user1, score: 1, received_at: '2020-08-02 10:00:00')
        end

        it 'rollbackをするための例外が発生する' do
          VCR.use_cassette 'models/monthly_ranks_updator/score_title_user1_500' do
            expect { MonthlyRanksUpdator.call }.to raise_error(ActiveRecord::Rollback)
          end
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

          VCR.use_cassette ['models/monthly_ranks_updator/score_title_user1_200', 'models/monthly_ranks_updator/score_title_user2_200', 'models/monthly_ranks_updator/score_title_user3_200'] do
            MonthlyRanksUpdator.call
          end
        end

        it 'monthly_ranksテーブルにデータが作成される' do
          expect(MonthlyRank.count).to eq 3

          ranks = MonthlyRank.all.order(:rank)
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
          create(:user_score, user: user1, score: 3, received_at: '2020-07-10 10:00:00')
          create(:user_score, user: user1, score: 2, received_at: '2020-07-10 10:00:00')
          create(:user_score, user: user1, score: 1, received_at: '2020-07-10 10:00:00')

          create(:user_score, user: user2, score: 10, received_at: '2020-06-10 10:00:00')
          create(:user_score, user: user2, score: 3, received_at: '2020-06-10 10:00:00')
          create(:user_score, user: user2, score: 4, received_at: '2020-06-10 10:00:00')

          create(:user_score, user: user3, score: 1, received_at: '2019-08-10 10:00:00')
          create(:user_score, user: user3, score: 1, received_at: '2019-08-10 10:00:00')
          create(:user_score, user: user3, score: 1, received_at: '2019-08-10 10:00:00')

          VCR.use_cassette ['models/monthly_ranks_updator/score_title_user1_200', 'models/monthly_ranks_updator/score_title_user2_200', 'models/monthly_ranks_updator/score_title_user3_200'] do
            MonthlyRanksUpdator.call
          end
        end

        it 'monthly_ranksテーブルは空である' do
          expect(MonthlyRank.count).to eq 0
        end
      end

      context 'スコア所持ユーザーが誰もいない場合' do
        before do
          create(:user)
          create(:user)
          create(:user)

          VCR.use_cassette ['models/monthly_ranks_updator/score_title_user1_200', 'models/monthly_ranks_updator/score_title_user2_200', 'models/monthly_ranks_updator/score_title_user3_200'] do
            MonthlyRanksUpdator.call
          end
        end

        it 'monthly_ranksテーブルは空である' do
          expect(MonthlyRank.count).to eq 0
        end
      end

      context 'ユーザーが存在しない場合' do
        before do
          VCR.use_cassette 'models/monthly_ranks_updator/score_title_user1_200' do
            MonthlyRanksUpdator.call
          end
        end

        it 'monthly_ranksテーブルは空である' do
          expect(MonthlyRank.count).to eq 0
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
