class AddTableIdToChart < ActiveRecord::Migration
  def change
    add_column :charts, :table_id, :integer
  end
end
