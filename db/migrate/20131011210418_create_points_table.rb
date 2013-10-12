class CreatePointsTable < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :pointable_type, null: false
      t.integer :pointable_id, null: false
      t.string :pointable_sub_type, null: false
      t.references :to_user, null: false, index: true
      t.references :from_user, index: true
      t.integer :points, null: false
      t.timestamps
    end
  end
end
