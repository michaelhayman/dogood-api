class AddLocationNameToGood < ActiveRecord::Migration
  def change
    add_column :goods, :location_name, :string
  end
end
