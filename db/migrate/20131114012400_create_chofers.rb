class CreateChofers < ActiveRecord::Migration
  def change
    create_table :chofers do |t|
      t.string :nombre
      t.integer :estado
    end
  end
end
