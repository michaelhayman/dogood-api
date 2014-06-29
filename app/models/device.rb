class Device < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :token, :provider

  def self.tokens_for(user_id)
    where(user_id: user_id).map(&:token)
  end
end

