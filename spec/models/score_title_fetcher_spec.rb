require 'rails_helper'

RSpec.describe ScoreTitleFetcher, type: :model do
  describe '#call' do
    let(:model) { ScoreTitleFetcher.new }
    let(:score) { 100 }

    it 'scoreに応じた称号が取得される' do
      VCR.use_cassette 'models/score_title_fetcher/score_title_200' do
        response = model.call(score)
        expect(response[:status]).to eq 200
        expect(response[:title]).to eq '努力少年'
      end
    end

    context 'apiの応答結果がステータスコード 200以外の場合' do
      it 'scoreに応じた称号が取得される' do
        VCR.use_cassette 'models/score_title_fetcher/score_title_500' do
          response = model.call(score)
          expect(response[:status]).to eq 500
          expect(response.key?(:title)).to eq false
        end
      end
    end
  end
end
