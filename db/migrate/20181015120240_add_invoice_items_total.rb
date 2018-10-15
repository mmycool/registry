class AddInvoiceItemsTotal < ActiveRecord::Migration
  def change
    add_column :invoice_items, :total, :decimal, precision: 10, scale: 2
  end
end
