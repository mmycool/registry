class RenameDirectosToDirectoConnections < ActiveRecord::Migration
  def change
    rename_table 'directos', 'directo_connections'
  end
end
