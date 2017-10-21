class RemoveDomainPeriodAndPeriodUnit < ActiveRecord::Migration
  def change
    remove_column :domains, :period, :integer
    remove_column :domains, :period_unit, :char
  end
end
