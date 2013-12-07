class IndexesDatesGamesMatches < ActiveRecord::Migration
  def change

    add_index :matches, :created_at
    add_index :games, :created_at
  end
end
