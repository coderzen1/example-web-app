class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer
    add_column :users, :role, :integer
    add_column :users, :status, :boolean, default: true
  end
end
