class CreateLocationsTable < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :company_id
      t.integer :ptv_location_id
      t.integer :address_id
      t.float :latitude
      t.float :longitude
    end
  end
end
