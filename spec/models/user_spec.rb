require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#total_score' do
    let(:user1) { create(:user) }

    context 'user_scoresテーブルにデータがある場合' do
      before do
        create(:user_score, user: user1, score: 4)
        create(:user_score, user: user1, score: 5)
        create(:user_score, user: user1, score: 6)
      end

      it 'スコアの合計を取得できる' do
        expect(user1.total_score).to eq 15
      end
    end

    context 'user_scoresテーブルにデータがない場合' do
      it 'スコアの合計は0である' do
        expect(user1.total_score).to eq 0
      end
    end
  end
end
