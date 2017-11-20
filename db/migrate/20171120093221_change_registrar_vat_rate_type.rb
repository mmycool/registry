class ChangeRegistrarVatRateType < ActiveRecord::Migration
  def change
    change_column :registrars, :vat_rate, :decimal, precision: 4, scale: 3
  end
end
