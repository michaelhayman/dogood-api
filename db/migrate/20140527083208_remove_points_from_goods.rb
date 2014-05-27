class RemovePointsFromGoods < ActiveRecord::Migration
  def change
    remove_column :goods, :points
  end
end
