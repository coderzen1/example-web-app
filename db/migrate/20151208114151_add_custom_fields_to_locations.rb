class AddCustomFieldsToLocations < ActiveRecord::Migration
  def change
    remove_column :companies, :custom_fields
    add_column :locations, :custom_fields, :string, array: true
  end
end
 
