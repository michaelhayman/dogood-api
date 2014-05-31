class Unsubscribe < ActiveRecord::Base
  def self.opted_out?(email)
    if email
      Unsubscribe.exists?(email: email)
    else
      true
    end
  end
end
