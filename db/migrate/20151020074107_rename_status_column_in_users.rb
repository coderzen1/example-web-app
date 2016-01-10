class RenameStatusColumnInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :status, :active
  end
end
