class CreateDashboardElements < ActiveRecord::Migration
  def change
    create_table :dashboard_elements do |t|
      t.integer :chart_id
      t.integer :dashboard_id
      t.timestamps
    end
  end
end
