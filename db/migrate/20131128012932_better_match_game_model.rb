class BetterMatchGameModel < ActiveRecord::Migration
  def up
    
    create_table :games do |t|
      t.string :log_a
      t.string :log_b
      t.string :log_c
      t.string :log_d
      t.string :log_server
      t.string :gamelog
      t.integer :winner_id
      t.integer :match_id
      t.integer :ai_1_id
      t.integer :ai_2_id
      t.string :commentaire
      t.timestamps
    end

    add_index :games, :winner_id
    add_index :games, :match_id

    remove_index :matches, :winner1_id
    remove_index :matches, :winner2_id

    remove_column :matches, :winner1_id
    remove_column :matches, :winner2_id
    remove_column :matches, :log1 
    remove_column :matches, :log2
  end

  def down
    drop_table :games
    add_column :matches, :winner1_id, :integer
    add_column :matches, :winner2_id, :integer
    add_column :matches, :log1, :string
    add_column :matches, :log2, :string
    add_index :matches, :winner1_id
    add_index :matches, :winner2_id

  end
end
