class CreateTableCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :address_id
      t.string :logo
      t.string :token
      t.string :dashboard_color
      t.string :language
      t.string :custom_fields, array: true
    end
  end
end
