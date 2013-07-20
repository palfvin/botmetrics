class AddNameToTables < ActiveRecord::Migration
  def change
    add_column :tables, :name, :string
  end
end
