class RemoveInvoicePaidAt < ActiveRecord::Migration
  def change
    remove_column :invoices, :paid_at
  end
end
