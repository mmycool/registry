class AddInvoicesAutoGenerated < ActiveRecord::Migration
  def change
    add_column :invoices, :auto_generated, :boolean, null: false, default: false
  end
end
