class AddZoneAccountingProductCode < ActiveRecord::Migration
  def change
    add_column :zones, :accounting_product_code, :string
    change_column_null :zones, :accounting_product_code, false, 'replace this with actual value'
  end
end
