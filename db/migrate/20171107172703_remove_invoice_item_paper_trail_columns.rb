class RemoveInvoiceItemPaperTrailColumns < ActiveRecord::Migration
  def change
    remove_column :invoice_items, :creator_str, :string
    remove_column :invoice_items, :updator_str, :string
  end
end
