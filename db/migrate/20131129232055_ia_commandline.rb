class IaCommandline < ActiveRecord::Migration
  def change
    add_column :ais, :command_line, :string
  end
end
