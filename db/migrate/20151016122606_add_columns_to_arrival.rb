class AddColumnsToArrival < ActiveRecord::Migration
  def change
    add_column :arrivals, :show_token, :string, limit: 24
    add_column :arrivals, :edit_token, :string, limit: 24
  end
end
