class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :token
      t.string :provider, :default => "apns"
      t.boolean :is_valid, :default => true
      t.references :user
      t.timestamps
    end

    add_index :devices, :token, :unique => true
    add_index :devices, :user_id
  end
end
