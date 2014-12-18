class CreateSearchModel < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.json    :data
      t.string  :sha
      t.boolean :processed

      t.timestamps
    end
  end
end
