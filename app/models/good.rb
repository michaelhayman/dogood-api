class Good < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :users, :through => :likes
  has_many :regoods
  has_many :comments

  # validates :caption, :message => "Enter a name."
  # validates :user_id, :message => "Goods must be associated with a user."
end
