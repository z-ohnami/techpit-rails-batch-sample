module Dev
  class ScoreTitleController < ApplicationController
    def index
      # 開発のサンプル用ということで、簡単のためコントローラーに直接処理を書いています。
      titles = [
        { max: 99, title: '期待のルーキー' },
        { max: 199, title: '努力少年' },
        { max: 299, title: 'ゲーム係長' },
        { max: 499, title: '一人前のゲームマン' },
        { max: 699, title: 'ゲーム狂' },
        { max: 999, title: '免許皆伝' }
      ]

      yours = titles.find { |t| params[:score].to_i <= t[:max] }
      title = yours.present? ? yours[:title] : '伝説のゲーム人'

      render json: { score: params[:score].to_i, title: title }, status: :ok
    end
  end
end
