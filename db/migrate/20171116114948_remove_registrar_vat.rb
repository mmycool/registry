class RemoveRegistrarVat < ActiveRecord::Migration
  def change
    remove_column :registrars, :vat, :boolean
  end
end
