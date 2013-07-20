class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :data_source
      t.text :data
      t.integer :user_id
      t.timestamps
    end
  end
end
