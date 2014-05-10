# encoding: UTF-8

class Float
  INFINITY = (1.0 / 0.0) unless defined?(INFINITY)

  NAN = (0.0 / 0.0) unless defined?(NAN)
end

