class ConvertPtvIdToString < ActiveRecord::Migration
  def change
    change_column :locations, :ptv_location_id, :string
  end
end
