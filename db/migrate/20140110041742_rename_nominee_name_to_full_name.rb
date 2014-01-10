class RenameNomineeNameToFullName < ActiveRecord::Migration
  def change
    rename_column :nominees, :name, :full_name
  end
end
