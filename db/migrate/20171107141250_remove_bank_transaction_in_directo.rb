class RemoveBankTransactionInDirecto < ActiveRecord::Migration
  def change
    remove_column :bank_transactions, :in_directo
  end
end
