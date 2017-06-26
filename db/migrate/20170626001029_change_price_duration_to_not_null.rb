class ChangePriceDurationToNotNull < ActiveRecord::Migration
  def change
    change_column :prices, :duration, :interval, null: false
  end
end
