class ConvertColorsToArray < ActiveRecord::Migration
  def change
    remove_column :companies, :dashboard_color
    add_column :companies, :dashboard_colors, :string, array: true
  end
end
