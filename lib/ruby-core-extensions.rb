module Ruby
  module CoreExtensions
    BASE_PATH = File.join(File.dirname(__FILE__), *%w{ ruby core-extensions })

    autoload :Nullable,
      File.join(Ruby::CoreExtensions::BASE_PATH, 'null_object')

    autoload :NullObject,
      File.join(Ruby::CoreExtensions::BASE_PATH, 'null_object')
  end
end

%w{
  traversable

  hash
}.each do |file|
  require File.join(Ruby::CoreExtensions::BASE_PATH, file)
end

