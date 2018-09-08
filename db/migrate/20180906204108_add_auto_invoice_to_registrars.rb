class AddAutoInvoiceToRegistrars < ActiveRecord::Migration
  def change
    add_column :registrars, :auto_invoice, :boolean, default: false, null: false
    add_column :registrars, :low_balance_threshold_cents, :integer
    add_column :registrars, :top_up_amount_cents, :integer
  end
end