class CreateEntitiesTable < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.text :link, :null => false
      t.integer :link_id, :null => false
      t.text :link_type, :null => false
      t.text :title, :null => false
      t.integer :entityable_id, :null => false
      t.string :entityable_type, :null => false
      # bug not allowing this to be an integer
      # t.integer :range, :array => true, :length => 2, :null => false
      t.string :range, :array => true, :length => 2, :null => false
    end
  end
end
