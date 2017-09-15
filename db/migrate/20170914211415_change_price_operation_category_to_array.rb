class ChangePriceOperationCategoryToArray < ActiveRecord::Migration
  def change
    change_column :prices, :operation_category, "varchar[] USING array[operation_category]", default: [], null: false
  end
end
