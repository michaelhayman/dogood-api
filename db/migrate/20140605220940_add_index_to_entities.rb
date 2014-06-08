class AddIndexToEntities < ActiveRecord::Migration
  def change
    add_index :entities, :title
    add_index :entities, [ :entityable_id, :entityable_type ]
    add_index :entities, :link_id
  end
end
