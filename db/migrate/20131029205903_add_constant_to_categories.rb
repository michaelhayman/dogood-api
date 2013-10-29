class AddConstantToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :name_constant, :text

    Category.all.each do |c|
      c.name_constant = c.name.parameterize
      c.save
    end
  end
end

