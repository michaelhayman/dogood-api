class AddSocialIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id, :bigint
    add_column :users, :twitter_id, :bigint
  end
end
