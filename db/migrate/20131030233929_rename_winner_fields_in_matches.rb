class RenameWinnerFieldsInMatches < ActiveRecord::Migration
  def change
    rename_column "matches", "winner", "winner_id"
    rename_column "matches", "winner1", "winner1_id"
    rename_column "matches", "winner2", "winner2_id"

  end
end
