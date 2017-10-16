class ChangePriceValidFromToNotNull < ActiveRecord::Migration
  def change
    change_column_null :prices, :valid_from, false
  end
end
