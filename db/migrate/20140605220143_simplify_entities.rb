class SimplifyEntities < ActiveRecord::Migration
  def change
    remove_column :entities, :link
  end
end
