class ChangePriceDurationToNotNull < ActiveRecord::Migration
  def change
    change_column_null :prices, :duration, false
  end
end
