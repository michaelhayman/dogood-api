class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.string :caption
      t.references :category, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
