class AddInviteFlagToNominee < ActiveRecord::Migration
  def change
    add_column :nominees, :invite, :boolean, default: false
  end
end
