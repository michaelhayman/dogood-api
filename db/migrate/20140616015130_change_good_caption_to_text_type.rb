class ChangeGoodCaptionToTextType < ActiveRecord::Migration
  def change
    change_column :goods, :caption, :text, null: false
  end
end
