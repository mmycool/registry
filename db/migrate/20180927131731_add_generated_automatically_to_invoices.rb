class AddGeneratedAutomaticallyToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :generated_automatically, :boolean, default: false, null: false
  end
end
