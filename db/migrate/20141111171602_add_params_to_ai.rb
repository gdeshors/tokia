class AddParamsToAi < ActiveRecord::Migration
  def change
    add_column :ais, :filename, :string
    add_column :ais, :language, :string
    add_column :ais, :firstparam, :string
  end
end
