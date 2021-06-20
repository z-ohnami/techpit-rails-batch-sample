class AddScoreIndexToRanks < ActiveRecord::Migration[6.0]
  def change
    add_index :ranks, :score, name: 'ranks_score_index'
  end
end
