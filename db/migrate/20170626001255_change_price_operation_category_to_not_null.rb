class ChangePriceOperationCategoryToNotNull < ActiveRecord::Migration
  def change
    change_column :prices, :operation_category, :string, null: false
  end
end
