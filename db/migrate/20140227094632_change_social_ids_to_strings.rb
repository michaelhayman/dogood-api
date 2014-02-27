class ChangeSocialIdsToStrings < ActiveRecord::Migration
  def change
    change_column :users, :twitter_id, :string
    change_column :users, :facebook_id, :string
  end
end
