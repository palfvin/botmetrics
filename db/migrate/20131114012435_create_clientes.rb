class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :modelo
      t.integer :tipdoc
    end
  end
end
