require 'rails_helper'

RSpec.describe UserScore, type: :model do
  let(:current_time) { '2020-08-11 10:00:00' }
  let(:received_at) { '2020-08-10 10:00:00' }
  let(:model) { UserScore.new(received_at: received_at) }

  around do |e|
    travel_to(current_time) { e.run }
  end

  describe '#this_month?' do
    subject { model.this_month? }

    it { is_expected.to eq true }

    context 'received_atが先月の場合' do
      let(:received_at) { '2020-07-10 10:00:00' }

      it { is_expected.to eq false }
    end

    context 'received_atが去年の同月の場合' do
      let(:received_at) { '2019-08-10 10:00:00' }

      it { is_expected.to eq false }
    end

    context 'current_timeが月初の場合' do
      let(:current_time) { '2020-09-01 10:00:00' }

      it { is_expected.to eq true }
    end

    context 'current_timeが2日目の場合' do
      let(:current_time) { '2020-09-02 10:00:00' }

      it { is_expected.to eq false }
    end
  end

  describe '#this_week?' do
    subject { model.this_week? }

    it { is_expected.to eq true }

    context 'received_atが先週の日曜日の場合' do
      let(:received_at) { '2020-08-09 10:00:00' }

      it { is_expected.to eq false }
    end

    context 'received_atが去年の同日の場合' do
      let(:received_at) { '2019-08-10 10:00:00' }

      it { is_expected.to eq false }
    end

    context 'current_timeが月曜日の場合' do
      let(:current_time) { '2020-08-10 10:00:00' }
      let(:received_at) { '2020-08-09 10:00:00' }

      it { is_expected.to eq true }
    end
  end

  describe '#yesterday?' do
    subject { model.yesterday? }

    it { is_expected.to eq true }

    context 'received_atが2日前の場合' do
      let(:received_at) { '2020-08-09 10:00:00' }

      it { is_expected.to eq false }
    end

    context 'received_atが去年の同日の場合' do
      let(:received_at) { '2019-08-10 10:00:00' }

      it { is_expected.to eq false }
    end
  end
end
