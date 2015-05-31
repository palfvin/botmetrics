class AddWebookUpdateToTables < ActiveRecord::Migration
  def change
    add_column :tables, :webhook_update, :boolean
  end
end
