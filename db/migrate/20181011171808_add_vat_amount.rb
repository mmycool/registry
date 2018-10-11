class AddVatAmount < ActiveRecord::Migration
  def change
    add_column :invoices, :vat_amount, :decimal, precision: 10, scale: 2
    add_column :invoice_items, :vat_amount, :decimal, precision: 10, scale: 2
  end
end
