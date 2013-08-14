class AddFollowsCountToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :follows_count, :integer, :default => 0
  end
end
