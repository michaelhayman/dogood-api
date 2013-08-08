class CreateRegoods < ActiveRecord::Migration
  def change
    create_table :regoods do |t|
      t.references :user, index: true
      t.references :good, index: true

      t.timestamps
    end
  end
end
