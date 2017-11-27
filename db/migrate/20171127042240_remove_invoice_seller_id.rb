class RemoveInvoiceSellerId < ActiveRecord::Migration
  def change
    remove_column :invoices, :seller_id, :integer
  end
end
