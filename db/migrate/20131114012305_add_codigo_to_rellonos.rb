class AddCodigoToRellonos < ActiveRecord::Migration
  def change
    add_column :rellonos, :codigo, :integer
  end
end
