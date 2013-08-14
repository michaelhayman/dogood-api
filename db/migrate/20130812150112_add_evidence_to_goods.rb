class AddEvidenceToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :evidence, :string
  end
end
