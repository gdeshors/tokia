class GameElos < ActiveRecord::Migration
  def change
    add_column :matches, :new_elo_1, :integer
    add_column :matches, :new_elo_2, :integer
   
  end
end
