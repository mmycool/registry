class RemoveInvoicePaymentTerm < ActiveRecord::Migration
  def change
    remove_column :invoices, :payment_term, :string
  end
end
