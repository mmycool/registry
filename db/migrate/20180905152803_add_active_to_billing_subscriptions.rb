class AddActiveToBillingSubscriptions < ActiveRecord::Migration
  def change
    add_column :billing_subscriptions, :active, :boolean, null: false
  end
end