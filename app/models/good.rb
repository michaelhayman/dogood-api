class Good < ActiveRecord::Base
  acts_as_commentable
  acts_as_likeable

  belongs_to :category
  belongs_to :user
  has_many :regoods

  # validates :caption, :message => "Enter a name."
  # validates :user_id, :message => "Goods must be associated with a user."
end
