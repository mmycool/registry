class AddRegistrarVatCountry < ActiveRecord::Migration
  def change
    add_column :registrars, :vat_country, :string
  end
end
