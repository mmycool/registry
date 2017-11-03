class RemoveAccountActivityCurrency < ActiveRecord::Migration
  def change
    remove_column :account_activities, :currency, :string
  end
end
