class AddInvoiceBuyerIdFk < ActiveRecord::Migration
  def change
    add_foreign_key :invoices, :registrars, column: :buyer_id, name: 'invoice_buyer_id_fk'
  end
end
