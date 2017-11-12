class AddRegistrarVatRate < ActiveRecord::Migration
  def change
    add_column :registrars, :vat_rate, :decimal, precision: 3, scale: 2
  end
end
