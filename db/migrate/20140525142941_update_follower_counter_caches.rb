class UpdateFollowerCounterCaches < ActiveRecord::Migration
  def change
    rename_column :goods, :follows_count, :followers_count
    rename_column :users, :follows_count, :followers_count
    add_column :goods, :following_count, :integer, :default => 0
    add_column :users, :following_count, :integer, :default => 0
  end
end
