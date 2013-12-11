require_relative '20131114012435_create_clientes.rb'
require_relative '20131114012400_create_chofers.rb'
require_relative '20131114012305_add_codigo_to_rellonos.rb'
require_relative '20131114012242_add_descripcion_to_rellonos.rb'
require_relative '20131114012059_create_rellonos.rb'

class UndoStackOverflowMigrations < ActiveRecord::Migration
  def change
    revert CreateClientes
    revert CreateChofers
    revert AddCodigoToRellonos
    revert AddDescripcionToRellonos
    revert CreateRellonos
  end
end