class AddFollowsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :follows_count, :integer, :default => 0
  end
end
