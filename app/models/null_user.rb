# encoding: UTF-8

class NullUser
  include Ruby::CoreExtensions::Nullable

  def first_name
    'Guest'
  end

  def logged_in?
    false
  end
end

