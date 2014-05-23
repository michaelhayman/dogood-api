class ChangeNomineeUserIdToInteger < ActiveRecord::Migration
  def change
    remove_column :nominees, :user_id
    add_column :nominees, :user_id, :integer, default: 0
  end
end
