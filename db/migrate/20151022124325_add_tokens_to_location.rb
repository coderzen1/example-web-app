class AddTokensToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :show_token, :string
    add_column :locations, :edit_token, :string
  end
end
