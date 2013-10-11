class AddLocationToGood < ActiveRecord::Migration
  def change
    add_column :goods, :lat, :float
    add_column :goods, :lng, :float
  end
end
