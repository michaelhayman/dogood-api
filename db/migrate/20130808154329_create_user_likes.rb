class CreateUserLikes < ActiveRecord::Migration
  def change
    create_table :user_likes do |t|
      t.references :user, index: true
      t.references :good, index: true

      t.timestamps
    end
  end
end
