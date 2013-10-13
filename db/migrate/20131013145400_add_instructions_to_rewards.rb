class AddInstructionsToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :instructions, :text
  end
end
