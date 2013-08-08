class ClaimedRewards < ActiveRecord::Migration
  def change
    create_table :claimed_rewards do |t|
      t.references :user, index: true
      t.references :reward, index: true

      t.timestamps
    end
  end
end
