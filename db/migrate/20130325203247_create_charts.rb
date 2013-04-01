class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.string :data_source
      t.string :chart_type

      t.timestamps
    end
  end
end
