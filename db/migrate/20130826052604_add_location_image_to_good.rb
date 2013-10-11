class AddLocationImageToGood < ActiveRecord::Migration
  def change
    add_column :goods, :location_image, :string
  end
end
