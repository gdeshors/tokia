class AddValidToUser < ActiveRecord::Migration
  def change
    add_column :users, :validated, :boolean, :default => false
  end
end
