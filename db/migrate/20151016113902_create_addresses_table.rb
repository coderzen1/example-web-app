class CreateAddressesTable < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.integer :number
      t.integer :zip_code
    end
  end
end
