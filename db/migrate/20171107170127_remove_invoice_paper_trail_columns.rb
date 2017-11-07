class RemoveInvoicePaperTrailColumns < ActiveRecord::Migration
  def change
    remove_column :invoices, :creator_str, :string
    remove_column :invoices, :updator_str, :string
  end
end
