class AddNameToDashboard < ActiveRecord::Migration
  def change
    add_column :dashboards, :name, :string
  end
end
