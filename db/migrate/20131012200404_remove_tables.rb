class RemoveTables < ActiveRecord::Migration
  def up
    drop_table :mentions
    drop_table :regoods
    drop_table :likes
    drop_table :user_likes
  end

  def down
  end
end
