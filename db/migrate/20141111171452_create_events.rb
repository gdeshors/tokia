class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string  :version
      t.integer :ai_id
      t.string  :commentaire

      t.timestamps
    end
  end
end
