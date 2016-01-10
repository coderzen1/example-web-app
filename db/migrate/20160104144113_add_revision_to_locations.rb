class AddRevisionToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :revision, :integer
  end
end
