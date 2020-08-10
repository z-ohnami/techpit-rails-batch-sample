class CreateRanks < ActiveRecord::Migration[6.0]
  def change
    create_table :ranks, comment: 'ゲーム内のランキング情報' do |t|
      t.string :year_month, null: false, comment: 'ランキングの年月'
      t.references :user, null: false, index: true, foreign_key: { on_delete: :restrict, on_update: :restrict }, comment: 'ユーザー'
      t.integer :rank, null: false, default: 0, index: true, comment: 'ユーザーの順位'

      t.timestamps null: false, default: -> { 'NOW()' }
    end

    add_index :ranks, %i[year_month user_id], unique: true
  end
end
