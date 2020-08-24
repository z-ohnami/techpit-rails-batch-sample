require 'rails_helper'

RSpec.describe RanksUpdator, type: :model do
  describe '.call' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

    shared_examples 'ランキング情報更新処理の検証' do
      context 'スコア所持ユーザーが1名いる場合' do
        before do
          create(:user_score, user: user1, score: 3)
          create(:user_score, user: user1, score: 2)
          create(:user_score, user: user1, score: 1)

          RanksUpdator.call
        end

        it 'ranksテーブルにデータが作成される' do
          expect(Rank.count).to eq 1

          rank = Rank.first
          expect(rank.rank).to eq 1
          expect(rank.score).to eq 6
        end
      end

      context 'スコア所持ユーザーが複数いる場合' do
        before do
          create(:user_score, user: user1, score: 3)
          create(:user_score, user: user1, score: 2)
          create(:user_score, user: user1, score: 1)

          create(:user_score, user: user2, score: 10)
          create(:user_score, user: user2, score: 3)
          create(:user_score, user: user2, score: 4)

          create(:user_score, user: user3, score: 1)
          create(:user_score, user: user3, score: 1)
          create(:user_score, user: user3, score: 1)

          RanksUpdator.call
        end

        it 'ranksテーブルにデータが作成される' do
          expect(Rank.count).to eq 3

          ranks = Rank.all.order(:rank)
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

      context 'スコア所持ユーザーが誰もいない場合' do
        before do
          create(:user)
          create(:user)
          create(:user)

          RanksUpdator.call
        end

        it 'ranksテーブルは空である' do
          expect(Rank.count).to eq 0
        end
      end

      context 'ユーザーが存在しない場合' do
        before do
          RanksUpdator.call
        end

        it 'ranksテーブルは空である' do
          expect(Rank.count).to eq 0
        end
      end
    end

    # 既存のランキング情報がまだ存在していない場合
    include_examples 'ランキング情報更新処理の検証'

    context '過去のランキング情報が残っている場合' do
      before do
        create(:rank, user: user1, rank: 3, score: 10)
        create(:rank, user: user2, rank: 2, score: 20)
        create(:rank, user: user3, rank: 1, score: 31)
      end

      include_examples 'ランキング情報更新処理の検証'
    end
  end
end
