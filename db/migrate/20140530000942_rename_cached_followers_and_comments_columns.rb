class RenameCachedFollowersAndCommentsColumns < ActiveRecord::Migration
  def change
    rename_column :goods, :followers_count, :cached_followers_count
    rename_column :goods, :following_count, :cached_following_count
    rename_column :goods, :comments_count, :cached_comments_count
    rename_column :users, :followers_count, :cached_followers_count
    rename_column :users, :following_count, :cached_following_count
  end
end
