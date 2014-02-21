# encoding: UTF-8

class NullUser
  include Zoocasa::CoreExtensions::Nullable

  def first_name
    'Guest'
  end

  def logged_in?
    false
  end
end

