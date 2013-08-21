class AddDescriptionToDashboards < ActiveRecord::Migration
  def change
    add_column :dashboards, :description, :string
  end
end
