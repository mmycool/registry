class ChangeVatRate < ActiveRecord::Migration
  def change
    change_column :registrars, :vat_rate, :decimal, precision: 5, scale: 3
    change_column :invoices, :vat_rate, :decimal, precision: 5, scale: 3
  end
end
