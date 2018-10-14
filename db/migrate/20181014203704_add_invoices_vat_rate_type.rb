class AddInvoicesVatRateType < ActiveRecord::Migration
  def change
    add_column :invoices, :vat_rate_type, :string
  end
end
