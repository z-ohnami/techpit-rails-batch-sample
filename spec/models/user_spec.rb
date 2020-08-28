require 'rails_helper'

RSpec.describe User, type: :model do
  let(:model) { User.new }
  let(:current_time) { '2020-08-11 10:00:00' }

  around do |e|
    travel_to(current_time) { e.run }
  end

  describe '#total_score' do
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

  describe '#monthly_total_score' do
    subject { model.monthly_total_score }

    context 'user_scoresが1件ある場合' do
      let(:received_at) { '2020-08-09 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at)
      end

      it { is_expected.to eq 3 }

      context 'user_scoresが1件あるが、期間外の場合' do
        let(:received_at) { '2020-07-09 10:00:00' }

        it { is_expected.to eq 0 }
      end
    end

    context 'user_scoresが2件以上ある場合' do
      let(:received_at1) { '2020-08-08 10:00:00' }
      let(:received_at2) { '2020-08-09 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at1)
        model.user_scores << UserScore.new(score: 4, received_at: received_at2)
      end

      it { is_expected.to eq 7 }

      context 'user_scoresの一部が、期間外の場合' do
        let(:received_at1) { '2020-06-08 10:00:00' }

        it { is_expected.to eq 4 }
      end

      context 'user_scoresの全てが、期間外の場合' do
        let(:received_at1) { '2020-06-08 10:00:00' }
        let(:received_at2) { '2020-05-08 10:00:00' }

        it { is_expected.to eq 0 }
      end
    end

    context 'user_scoresがそもそも0件の場合' do
      it { is_expected.to eq 0 }
    end
  end

  describe '#monthly_score_hold?' do
    subject { model.monthly_score_hold? }

    context 'user_scoresが1件ある場合' do
      let(:received_at) { '2020-08-09 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at)
      end

      it { is_expected.to eq true }

      context 'user_scoresが1件あるが、期間外の場合' do
        let(:received_at) { '2020-07-09 10:00:00' }

        it { is_expected.to eq false }
      end
    end

    context 'user_scoresが2件以上ある場合' do
      let(:received_at1) { '2020-08-08 10:00:00' }
      let(:received_at2) { '2020-08-09 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at1)
        model.user_scores << UserScore.new(score: 4, received_at: received_at2)
      end

      it { is_expected.to eq true }

      context 'user_scoresの一部が、期間外の場合' do
        let(:received_at1) { '2020-06-08 10:00:00' }

        it { is_expected.to eq true }
      end

      context 'user_scoresの全てが、期間外の場合' do
        let(:received_at1) { '2020-06-08 10:00:00' }
        let(:received_at2) { '2020-05-08 10:00:00' }

        it { is_expected.to eq false }
      end
    end

    context 'user_scoresがそもそも0件の場合' do
      it { is_expected.to eq false }
    end
  end

  describe '#weekly_total_score' do
    subject { model.weekly_total_score }

    context 'user_scoresが1件ある場合' do
      let(:received_at) { '2020-08-10 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at)
      end

      it { is_expected.to eq 3 }

      context 'user_scoresが1件あるが、期間外の場合' do
        let(:received_at) { '2020-08-09 10:00:00' }

        it { is_expected.to eq 0 }
      end
    end

    context 'user_scoresが2件以上ある場合' do
      let(:received_at1) { '2020-08-10 10:00:00' }
      let(:received_at2) { '2020-08-10 11:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at1)
        model.user_scores << UserScore.new(score: 4, received_at: received_at2)
      end

      it { is_expected.to eq 7 }

      context 'user_scoresの一部が、期間外の場合' do
        let(:received_at1) { '2020-08-09 10:00:00' }

        it { is_expected.to eq 4 }
      end

      context 'user_scoresの全てが、期間外の場合' do
        let(:received_at1) { '2020-08-08 10:00:00' }
        let(:received_at2) { '2020-08-09 10:00:00' }

        it { is_expected.to eq 0 }
      end
    end

    context 'user_scoresがそもそも0件の場合' do
      it { is_expected.to eq 0 }
    end
  end

  describe '#weekly_score_hold?' do
    subject { model.weekly_score_hold? }

    context 'user_scoresが1件ある場合' do
      let(:received_at) { '2020-08-10 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at)
      end

      it { is_expected.to eq true }

      context 'user_scoresが1件あるが、期間外の場合' do
        let(:received_at) { '2020-08-09 10:00:00' }

        it { is_expected.to eq false }
      end
    end

    context 'user_scoresが2件以上ある場合' do
      let(:received_at1) { '2020-08-10 10:00:00' }
      let(:received_at2) { '2020-08-10 11:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at1)
        model.user_scores << UserScore.new(score: 4, received_at: received_at2)
      end

      it { is_expected.to eq true }

      context 'user_scoresの一部が、期間外の場合' do
        let(:received_at1) { '2020-08-09 10:00:00' }

        it { is_expected.to eq true }
      end

      context 'user_scoresの全てが、期間外の場合' do
        let(:received_at1) { '2020-08-08 10:00:00' }
        let(:received_at2) { '2020-08-09 10:00:00' }

        it { is_expected.to eq false }
      end
    end

    context 'user_scoresがそもそも0件の場合' do
      it { is_expected.to eq false }
    end
  end

  describe '#daily_total_score' do
    subject { model.daily_total_score }

    context 'user_scoresが1件ある場合' do
      let(:received_at) { '2020-08-10 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at)
      end

      it { is_expected.to eq 3 }

      context 'user_scoresが1件あるが、期間外の場合' do
        let(:received_at) { '2020-08-09 10:00:00' }

        it { is_expected.to eq 0 }
      end
    end

    context 'user_scoresが2件以上ある場合' do
      let(:received_at1) { '2020-08-10 10:00:00' }
      let(:received_at2) { '2020-08-10 11:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at1)
        model.user_scores << UserScore.new(score: 4, received_at: received_at2)
      end

      it { is_expected.to eq 7 }

      context 'user_scoresの一部が、期間外の場合' do
        let(:received_at1) { '2020-08-08 10:00:00' }

        it { is_expected.to eq 4 }
      end

      context 'user_scoresの全てが、期間外の場合' do
        let(:received_at1) { '2020-08-08 10:00:00' }
        let(:received_at2) { '2020-08-07 10:00:00' }

        it { is_expected.to eq 0 }
      end
    end

    context 'user_scoresがそもそも0件の場合' do
      it { is_expected.to eq 0 }
    end
  end

  describe '#daily_score_hold?' do
    subject { model.daily_score_hold? }

    context 'user_scoresが1件ある場合' do
      let(:received_at) { '2020-08-10 10:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at)
      end

      it { is_expected.to eq true }

      context 'user_scoresが1件あるが、期間外の場合' do
        let(:received_at) { '2020-08-09 10:00:00' }

        it { is_expected.to eq false }
      end
    end

    context 'user_scoresが2件以上ある場合' do
      let(:received_at1) { '2020-08-10 10:00:00' }
      let(:received_at2) { '2020-08-10 11:00:00' }

      before do
        model.user_scores << UserScore.new(score: 3, received_at: received_at1)
        model.user_scores << UserScore.new(score: 4, received_at: received_at2)
      end

      it { is_expected.to eq true }

      context 'user_scoresの一部が、期間外の場合' do
        let(:received_at1) { '2020-08-09 10:00:00' }

        it { is_expected.to eq true }
      end

      context 'user_scoresの全てが、期間外の場合' do
        let(:received_at1) { '2020-08-09 10:00:00' }
        let(:received_at2) { '2020-08-08 10:00:00' }

        it { is_expected.to eq false }
      end
    end

    context 'user_scoresがそもそも0件の場合' do
      it { is_expected.to eq false }
    end
  end
end
