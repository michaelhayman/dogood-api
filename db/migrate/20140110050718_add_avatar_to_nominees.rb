class AddAvatarToNominees < ActiveRecord::Migration
  def change
    add_column :nominees, :avatar, :string
  end
end
