class CreateUserRewards < ActiveRecord::Migration
  def change
    create_table :user_rewards do |t|
      t.references :user, index: true
      t.references :reward, index: true

      t.timestamps
    end
  end
end
