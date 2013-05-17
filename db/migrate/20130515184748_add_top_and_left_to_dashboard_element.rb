class AddTopAndLeftToDashboardElement < ActiveRecord::Migration
  def change
    add_column :dashboard_elements, :top, :integer
    add_column :dashboard_elements, :left, :integer
  end
end
