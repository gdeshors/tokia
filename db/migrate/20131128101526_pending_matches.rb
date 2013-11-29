class PendingMatches < ActiveRecord::Migration
  def change
    create_table :pending_games do |t|
      t.integer :game_id
      t.timestamps
    end
  end
end
