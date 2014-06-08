class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :reports, :user_id
    add_index :goods, :nominee_id
    add_index :nominees, :user_id
  end
end
