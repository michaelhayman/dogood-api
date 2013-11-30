class AddNomineeToGood < ActiveRecord::Migration
  def change
    add_column :goods, :nominee_user_id, :integer
  end
end
