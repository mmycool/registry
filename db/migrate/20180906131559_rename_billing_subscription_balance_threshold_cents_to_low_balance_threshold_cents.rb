class RenameBillingSubscriptionBalanceThresholdCentsToLowBalanceThresholdCents < ActiveRecord::Migration
  def change
    rename_column :billing_subscriptions, :balance_threshold_cents, :low_balance_threshold_cents
  end
end