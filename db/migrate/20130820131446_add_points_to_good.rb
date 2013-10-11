class AddPointsToGood < ActiveRecord::Migration
  def change
    add_column :goods, :points, :integer, :default => 0
  end
end
