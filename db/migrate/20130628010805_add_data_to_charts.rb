class AddDataToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :data, :text
  end
end
