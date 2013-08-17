class RenameRewardFields < ActiveRecord::Migration
  def change
    rename_column :rewards, :description, :subtitle
    rename_column :rewards, :name, :title
    add_column :rewards, :full_description, :text
  end
end
