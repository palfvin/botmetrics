class RemoveDataFromCharts < ActiveRecord::Migration
  def change
    remove_column :charts, :data, :text
  end
end
