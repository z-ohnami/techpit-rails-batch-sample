require 'rails_helper'

RSpec.describe RankOrderMaker, type: :model do
  describe '#call' do
    let(:user1) { create(:user, created_at: '2020-08-01 23:00:00') }
    let(:user2) { create(:user, created_at: '2020-08-05 23:00:00') }
    let(:user3) { create(:user, created_at: '2020-09-01 23:00:00') }

    context '各ユーザーのtotal_scoreが異なっている場合' do
      before do
        create(:user_score, user: user1, score: 4)
        create(:user_score, user: user1, score: 5)
        create(:user_score, user: user1, score: 6)

        create(:user_score, user: user2, score: 7)
        create(:user_score, user: user2, score: 8)
        create(:user_score, user: user2, score: 9)

        create(:user_score, user: user3, score: 10)
        create(:user_score, user: user3, score: 11)
        create(:user_score, user: user3, score: 12)
      end

      it 'スコアの高い順(降順)にuserとindexを取得できる' do
        orders = {}

        RankOrderMaker.new.call do |user, index|
          orders[user.id] = index
        end

        expect(orders.size).to eq 3
        expect(orders[user3.id]).to eq 1
        expect(orders[user2.id]).to eq 2
        expect(orders[user1.id]).to eq 3
      end
    end

    context '同じtotal_scoreを持つユーザーがいる場合' do
      before do
        create(:user_score, user: user1, score: 4)
        create(:user_score, user: user1, score: 5)
        create(:user_score, user: user1, score: 6)

        create(:user_score, user: user2, score: 4)
        create(:user_score, user: user2, score: 5)
        create(:user_score, user: user2, score: 6)

        create(:user_score, user: user3, score: 10)
        create(:user_score, user: user3, score: 11)
        create(:user_score, user: user3, score: 12)
      end

      it 'スコアの高い順(降順)にuserとindexを取得できる' do
        orders = {}

        RankOrderMaker.new.call do |user, index|
          orders[user.id] = index
        end

        expect(orders.size).to eq 3
        expect(orders.size).to eq 3
        expect(orders[user3.id]).to eq 1
        expect(orders[user2.id]).to eq 2
        expect(orders[user1.id]).to eq 2
      end
    end

    context 'ユーザーが存在していない場合' do
      it '順位付けは実行されない' do
        orders = {}

        RankOrderMaker.new.call do |user, index|
          orders[user.id] = index
        end

        expect(orders.size).to eq 0
      end
    end
  end
end
