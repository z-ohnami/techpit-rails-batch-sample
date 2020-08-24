class AddScoreIndexToRanks < ActiveRecord::Migration[6.0]
  def change
    add_index :ranks, :score
  end
end
