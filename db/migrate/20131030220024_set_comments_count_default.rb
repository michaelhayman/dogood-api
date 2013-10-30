class SetCommentsCountDefault < ActiveRecord::Migration
  def up
    change_column :goods, :comments_count, :integer, null: false
  end

  def down
    change_column :goods, :comments_count, :integer
  end
end
