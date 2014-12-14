class DropDualIndexOnEntityable < ActiveRecord::Migration
  def change
    remove_index :entities, [ :entityable_id, :entityable_type ]
    add_index :entities, :entityable_id
  end
end
