class ChangeInvoiceExportedToNotNull < ActiveRecord::Migration
  def change
    change_column_null :invoices, :exported, false, false
  end
end
