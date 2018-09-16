class ChangeInvoiceItemsAmountToNotNull < ActiveRecord::Migration
  def change
    change_column_null :invoice_items, :amount, false
  end
end
