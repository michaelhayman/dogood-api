class AddTeaserToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :teaser, :string
  end
end
