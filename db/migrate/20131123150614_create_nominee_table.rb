class CreateNomineeTable < ActiveRecord::Migration
  def change
    create_table :nominees do |t|
      t.string :name, :null => false
      t.string :email
      t.string :phone
      t.string :user_id
      t.string :twitter_id
      t.string :facebook_id
    end
  end
end
