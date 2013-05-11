class AddNameToCharts < ActiveRecord::Migration

  def change
    add_column :charts, :name, :string
  end

end
