class AddRegistrarsVATRateType < ActiveRecord::Migration
  def change
    add_column :registrars, :vat_rate_type, :string
  end
end
