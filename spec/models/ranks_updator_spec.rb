require 'rails_helper'

RSpec.describe RanksUpdater, type: :model do
  describe '.call' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

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
    end

    shared_examples 'ランキング情報更新処理の検証' do
      it 'ranksテーブルにデータが作成される' do
        RanksUpdater.new.update_all

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

    context 'ranksテーブルにすでにデータが存在している場合' do
      include_examples 'ランキング情報更新処理の検証'
    end


    context 'ranksテーブルにすでにデータが存在している場合' do
      before do
        create(:rank, user: user1, rank: 3, score: 10)
        create(:rank, user: user2, rank: 2, score: 20)
        create(:rank, user: user3, rank: 1, score: 31)
      end

      include_examples 'ランキング情報更新処理の検証'
    end
  end
end
