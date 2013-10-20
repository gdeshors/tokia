class CreateAis < ActiveRecord::Migration
  def change
    create_table :ais do |t|
      t.string :name
      t.boolean :active
      t.integer :elo
      t.string :version
      t.integer :user_id

      t.timestamps
    end
  end
end
