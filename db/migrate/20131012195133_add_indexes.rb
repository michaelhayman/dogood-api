class AddIndexes < ActiveRecord::Migration
  def change
    add_index :points, [:pointable_id, :pointable_type]
    add_index :reports, [:reportable_id, :reportable_type]
    add_index :users, :facebook_id
    add_index :users, :twitter_id
  end
end
