class AddCommentCount < ActiveRecord::Migration
  def change
    add_column :goods, :comments_count, :integer
  end
end
