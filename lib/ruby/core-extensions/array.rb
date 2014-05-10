# encoding: UTF-8

class ::Array
  include Zoocasa::CoreExtensions::Traversable

  # Converts a Ruby Array into a properly formatted string for PostgreSQL.
  #
  # Options:
  #
  # * :type - forces a particular data type for the array values. See
  #   Object#to_sql_array for possible values, the default of which is
  #   :text.
  def to_sql_array options = {}
    options = {
      :type => :text
    }.merge options

    'ARRAY[' + self.collect { |x|
      if x.is_a?(Array)
        x.join.to_sql_array(options)
      else
        x.to_sql_array(options)
      end
    }.join(',') + ']'
  end

  # Cuts of the n element(s) in the Array.
  def chop n = 1
    n = self.length - n - 1
    if n < 0
      []
    elsif n == 0
      [ self.first ]
    else
      self[0..n]
    end
  end

  # In-place version of Array#chop.
  def chop! n = 1
    self.replace(self.chop(n))
  end

  # Like Enumerable#each_slice mashed with Enumerable#collect.
  def collect_slice(n)
    retval = Array.new
    self.each_slice(n) do |r|
      if block_given?
        retval << yield(r)
      else
        retval << r
      end
    end
    retval
  end
  alias :map_slice :collect_slice

  def avg
    self.sum / self.length.to_f
  end

  # Returns the first truthy value that can be found. If the :allow_blank
  # option is true, we just check for any non-false values, while if the
  # :allow_blank option is false, we check for any values that are truthy
  # and non-empty by calling #present?.
  def coalesce(options = {})
    options = {
      :allow_blank => false
    }.merge(options)

    detector = if options[:allow_blank]
      proc { |value|
        value
      }
    else
      proc { |value|
        value.present?
      }
    end

    self.detect(&detector)
  end

  # Deeply strip all whitespace destructively.
  def deep_strip!
    self.each do |value|
      if value.respond_to?(:deep_strip!)
        value.deep_strip!
      elsif value.respond_to?(:strip!)
        value.strip!
      end
    end
  end

  # Deeply strip all whitespace.
  def deep_strip
    ret = []
    self.each_with_index do |value, i|
      ret[i] = if value.respond_to?(:deep_strip!)
        value.deep_strip
      elsif value.respond_to?(:strip!)
        value.strip
      else
        value
      end
    end
    ret
  end
end
