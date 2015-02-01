class NullUser
  include Ruby::CoreExtensions::Nullable

  def nil?
    false
  end

  def present?
    true
  end

  def first_name
    'Guest'
  end

  def logged_in?
    false
  end
end

