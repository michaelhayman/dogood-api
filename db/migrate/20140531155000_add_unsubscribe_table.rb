class AddUnsubscribeTable < ActiveRecord::Migration
  def change
    create_table :unsubscribes do |u|
      u.text :email, null: false, unique: true
    end

    add_index :unsubscribes, :email
  end
end
