class ChangePriceDurationToArray < ActiveRecord::Migration
  def change
    change_column :prices, :duration, "interval[] USING array[duration]", default: []
  end
end
