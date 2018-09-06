class CreateBillingSubscriptions < ActiveRecord::Migration
  def change
    create_table :billing_subscriptions do |t|
      t.references :registrar, foreign_key: true, null: false
      t.integer :balance_threshold_cents, null: false
      t.integer :top_up_amount_cents, null: false
      t.index :registrar_id, unique: true
    end
  end
end