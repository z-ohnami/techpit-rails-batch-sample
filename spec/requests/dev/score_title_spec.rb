require 'rails_helper'

describe 'スコアに応じた称号の取得(開発用のAPI)', type: :request do
  describe 'GET /dev/score_title' do
    let(:score) { 10 }
    let(:expected_title) { '期待のルーキー' }

    shared_examples '称号を取得する' do
      it 'スコアに応じた称号が取得される', :aggregate_failures do
        get '/dev/score_title', params: { score: score }

        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)
        expect(json_response['score']).to eq score
        expect(json_response['title']).to eq expected_title
      end
    end

    include_examples '称号を取得する'

    context '閾値と同じスコアが設定されていた場合' do
      let(:score) { 199 }
      let(:expected_title) { '努力少年' }

      include_examples '称号を取得する'
    end

    context 'あらかじめ設定していた閾値を超過している場合' do
      let(:score) { 10_000 }
      let(:expected_title) { '伝説のゲーム人' }

      include_examples '称号を取得する'
    end
  end
end
