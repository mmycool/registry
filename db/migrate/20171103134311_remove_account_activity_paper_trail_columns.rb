class RemoveAccountActivityPaperTrailColumns < ActiveRecord::Migration
  def change
    remove_column :account_activities, :creator_str, :string
    remove_column :account_activities, :updator_str, :string
  end
end
