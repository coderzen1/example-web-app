class RemoveLimitFromTokens < ActiveRecord::Migration
  def change
    change_column :arrivals, :show_token, :string, :limit => nil
    change_column :arrivals, :edit_token, :string, :limit => nil
  end
end
