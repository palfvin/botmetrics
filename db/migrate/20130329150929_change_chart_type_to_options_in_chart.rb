class ChangeChartTypeToOptionsInChart < ActiveRecord::Migration
  change_table :charts do |t|
    t.rename :chart_type, :options
  end
end
