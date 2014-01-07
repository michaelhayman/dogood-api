class RenameNomineeFieldInGoodsTable < ActiveRecord::Migration
  def change
    rename_column :goods, :nominee_user_id, :nominee_id
  end
end
