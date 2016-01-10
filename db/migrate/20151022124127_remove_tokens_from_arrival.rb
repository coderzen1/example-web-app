class RemoveTokensFromArrival < ActiveRecord::Migration
  def change
    remove_column :arrivals, :show_token, :string
    remove_column :arrivals, :edit_token, :string
  end
end
