require 'rails_helper'

RSpec.describe Chapter3Refactoring::RankOrderMaker, type: :model do
  describe '#call' do
    let(:score1) { 1 }
    let(:score2) { 2 }
    let(:score3) { 3 }

    context 'scoreが1件ずつ、異なる場合' do
      before do
        create(:rank, rank: 0, score: score1)
        create(:rank, rank: 0, score: score2)
        create(:rank, rank: 0, score: score3)
      end

      it 'スコアの高さに応じて順位が設定される' do
        orders = {}

        Chapter3Refactoring::RankOrderMaker.new.call do |score, rank|
          orders[score] = rank
        end

        expect(orders.size).to eq 3
        expect(orders[score1]).to eq 3
        expect(orders[score2]).to eq 2
        expect(orders[score3]).to eq 1
      end
    end

    context 'scoreに重複が見られる場合' do
      let(:score1) { 1 }
      let(:score2) { 2 }
      let(:score3) { 2 }

      before do
        create(:rank, rank: 0, score: score1)
        create(:rank, rank: 0, score: score2)
        create(:rank, rank: 0, score: score3)
      end

      it 'スコアの高さに応じて順位が設定される' do
        orders = {}

        Chapter3Refactoring::RankOrderMaker.new.call do |score, rank|
          orders[score] = rank
        end

        expect(orders.size).to eq 2
        expect(orders[score1]).to eq 2
        expect(orders[score2]).to eq 1
        expect(orders[score3]).to eq 1
      end
    end

    context 'ユーザーが存在していない場合' do
      it '順位付けは実行されない' do
        orders = {}

        Chapter3Refactoring::RankOrderMaker.new.call do |score, rank|
          orders[score] = rank
        end

        expect(orders.size).to eq 0
      end
    end
  end
end
