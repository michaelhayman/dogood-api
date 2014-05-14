class RemoveNullConstraintFromComments < ActiveRecord::Migration
  def change
    change_column :goods, :comments_count, :integer, default: 0, null: true
  end
end
