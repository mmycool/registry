class RemovePriceVersionRemnants < ActiveRecord::Migration
  def change
    remove_column :prices, :creator_str, :string
    remove_column :prices, :updator_str, :string
  end
end
