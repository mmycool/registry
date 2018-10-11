class AddInvoiceItemsVatRate < ActiveRecord::Migration
  def change
    add_column :invoice_items, :vat_rate, :decimal, precision: 3, scale: 1
  end
end
