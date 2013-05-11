class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.integer :owner_id
      t.timestamps
    end
  end
end
