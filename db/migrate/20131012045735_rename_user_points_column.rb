class RenameUserPointsColumn < ActiveRecord::Migration
  def change
    rename_column :users, :points, :points_cache
  end
end
