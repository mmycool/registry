class ChangeInvoiceDueDateToDate < ActiveRecord::Migration
  def change
    change_column :invoices, :due_date, :date, null: false
  end
end
