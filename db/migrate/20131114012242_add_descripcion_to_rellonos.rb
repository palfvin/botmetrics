class AddDescripcionToRellonos < ActiveRecord::Migration
  def change
    add_column :rellonos, :descripcion, :string
  end
end
