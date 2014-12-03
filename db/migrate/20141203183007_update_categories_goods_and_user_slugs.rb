class UpdateCategoriesGoodsAndUserSlugs < ActiveRecord::Migration
  def up
    User.all.each do |u|
      u.save
    end

    Category.all.each do |u|
      u.save
    end

    Good.all.each do |u|
      u.save
    end
  end

  def down
    # no-op
  end
end
