require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#total_score' do
    let(:model) { User.new }

    subject { model.total_score }

    context 'user_scoresが1件ある場合' do
      before do
        model.user_scores << UserScore.new(score: 3, received_at: Time.current)
      end

      it { is_expected.to eq 3 }
    end

    context 'user_scoresが2件以上ある場合' do
      before do
        model.user_scores << UserScore.new(score: 3, received_at: Time.current)
        model.user_scores << UserScore.new(score: 4, received_at: Time.current)
      end

      it { is_expected.to eq 7 }
    end

    context 'user_scoresが0件の場合' do
      it { is_expected.to eq 0 }
    end
  end
end
