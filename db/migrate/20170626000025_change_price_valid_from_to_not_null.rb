class ChangePriceValidFromToNotNull < ActiveRecord::Migration
  def change
    change_column :prices, :valid_from, :datetime, null: false
  end
end
