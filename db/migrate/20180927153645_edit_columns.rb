class EditColumns < ActiveRecord::Migration
  def change
    rename_column :registrars, :auto_invoice, :auto_invoice_enabled

    rename_column :registrars, :low_balance_threshold_cents, :auto_invoice_low_balance_threshold
    change_column :registrars, :auto_invoice_low_balance_threshold, :decimal, precision: 10, scale: 2

    rename_column :registrars, :top_up_amount_cents, :auto_invoice_top_up_amount
    change_column :registrars, :auto_invoice_top_up_amount, :decimal, precision: 10, scale: 2
  end
end
