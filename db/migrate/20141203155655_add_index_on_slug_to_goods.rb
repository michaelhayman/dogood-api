class AddIndexOnSlugToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :slug, :string
    add_index :goods, :slug
  end
end
