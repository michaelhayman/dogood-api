class AddCostAndQuantityToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :cost, :integer, :default => 0
    add_column :rewards, :quantity, :integer, :default => 0
    add_column :rewards, :quantity_remaining, :integer, :default => 0
  end
end
