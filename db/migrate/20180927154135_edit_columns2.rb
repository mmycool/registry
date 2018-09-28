class EditColumns2 < ActiveRecord::Migration
  def change
    rename_column :registrars, :iban, :auto_invoice_iban
  end
end
