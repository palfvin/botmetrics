class AddWidthAndHeightToDashboardElement < ActiveRecord::Migration
  def change
    add_column :dashboard_elements, :width, :integer
    add_column :dashboard_elements, :height, :integer
  end
end
