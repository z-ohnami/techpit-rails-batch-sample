class CreateUserScores < ActiveRecord::Migration[6.0]
  def change
    create_table :user_scores, comment: 'ユーザーがゲーム内で獲得した点数' do |t|
      t.references :user, null: false, index: true, foreign_key: { on_delete: :cascade, on_update: :cascade }, comment: 'ユーザー'
      t.integer :score, null: false, default: 0, comment: 'ユーザーが獲得した点数'
      t.datetime :received_at, null: false, index: true, comment: '点数を獲得した日時'

      t.timestamps null: false
    end
  end
end
