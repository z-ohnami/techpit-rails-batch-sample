class CreateMonthlyRanks < ActiveRecord::Migration[6.0]
  def change
    create_table :monthly_ranks, comment: '当月の累計スコアに基づくランキング情報' do |t|
      t.references :user, null: false, index: { unique: true }, foreign_key: { on_delete: :restrict, on_update: :restrict }, comment: 'ユーザー'
      t.integer :rank, null: false, default: 0, index: true, comment: 'ユーザーの順位'
      t.integer :score, null: false, default: 0, comment: 'このランクに至ったスコアの累計'
      t.string :score_title, null: false, default: '', comment: 'スコアに基づく称号'

      t.timestamps null: false
    end
  end
end
