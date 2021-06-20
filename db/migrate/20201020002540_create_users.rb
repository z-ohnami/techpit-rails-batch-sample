class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, comment: 'ゲームのユーザー情報を管理するテーブル' do |t|
      t.string :name, null: false, comment: 'ユーザーの名前'

      t.timestamps null: false
    end
  end
end
