class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :ai_1_id
      t.integer :ai_2_id
      t.integer :winner
      t.integer :winner1
      t.integer :winner2
      t.string :log1
      t.string :log2

      t.timestamps
    end
    add_index :matches, :ai_1_id
    add_index :matches, :ai_2_id
    add_index :matches, :winner
    add_index :matches, :winner1
    add_index :matches, :winner2
  end
end
