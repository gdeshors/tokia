class AddCarteslogAndEndingToGame < ActiveRecord::Migration
  def change
    add_column :games, :log_cartes, :string
    add_column :games, :ending, :string
  end
end
