class RemoveUnnecessaryDirectoConnectionColumns < ActiveRecord::Migration
  def change
    remove_column :directo_connections, :item_id
    remove_column :directo_connections, :item_type
    remove_column :directo_connections, :updated_at
    remove_column :directo_connections, :invoice_number
  end
end
