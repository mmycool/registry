class RemoveAccountPaperTrailColumns < ActiveRecord::Migration
  def change
    remove_column :accounts, :creator_str, :string
    remove_column :accounts, :updator_str, :string
  end
end
