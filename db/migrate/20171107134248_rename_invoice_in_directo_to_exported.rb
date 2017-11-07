class RenameInvoiceInDirectoToExported < ActiveRecord::Migration
  def change
    rename_column :invoices, :in_directo, :exported
  end
end
