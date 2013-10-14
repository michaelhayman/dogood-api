class AddDoneFlagToGood < ActiveRecord::Migration
  def change
    add_column :goods, :done, :boolean, :default => true
  end
end
