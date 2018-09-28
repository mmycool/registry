class EditColumns3 < ActiveRecord::Migration
  def change
    rename_column :registrars, :auto_invoice_enabled, :auto_invoice_activated
  end
end
