class CreateArrivalsTable < ActiveRecord::Migration
  def change
    create_table :arrivals do |t|
      t.integer :location_id
      t.string :scemid
      t.datetime :pta
      t.integer :vehicle_type
      t.json :custom_fields
    end
  end
end
