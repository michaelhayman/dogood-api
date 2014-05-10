# encoding: UTF-8

class ::Hash
  include Ruby::CoreExtensions::Traversable

  # Merges self with another hash, recursively.
  #
  # This code was lovingly stolen from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  #
  # Thanks to whoever made it.
  if !defined?(Rails) || Rails.version < '3'
    def deep_merge(hash)
      self.dup.deep_merge!(hash)
    end

    # In-place verison of deep_merge.
    def deep_merge!(hash)
      hash.keys.each do |key|
        if hash[key].is_a?(Hash) && self[key].is_a?(Hash)
          self[key] = self[key].deep_merge(hash[key])
        else
          self[key] = hash[key]
        end
      end

      self
    end
  end

  def reverse_deep_merge(hash)
    self.dup.reverse_deep_merge!(hash)
  end

  def reverse_deep_merge!(hash)
    hash.keys.each do |key|
      if hash[key].is_a?(Hash) && self[key].is_a?(Hash)
        self[key] = self[key].reverse_deep_merge(hash[key])
      elsif self[key].nil?
        self[key] = hash[key]
      end
    end

    self
  end

  # Like Hash#merge, but only merges existing keys.
  def existing_merge(hash)
    self.dup.existing_merge!(hash)
  end

  # Same as Hash#existing_merge but modifies the Hash
  # in place.
  def existing_merge!(hash)
    self.keys.each do |k|
      self[k] = hash[k] if hash.has_key?(k)
    end
    self
  end

  # Merge using the filter given in &block. The block will be passed the
  # key and value of each element in the Hash and merges when the block
  # evaluates to true.
  def filter_merge hash, &block
    self.dup.filter_merge!(hash, &block)
  end

  # In-place version of Hash#filter_merge.
  def filter_merge! hash, &block
    hash.keys.each do |key|
      value = hash[key]
      self[key] = value if yield(key, value)
    end
    self
  end

  # Return a new Hash with all keys converted to camelized Strings.
  def camelize_keys c = :upper
    inject(self.class.new) do |options, (key, value)|
      options[key.to_s.camelize(c)] = value
      options
    end
  end

  # Destructively convert all keys to camelized Strings.
  def camelize_keys! c = :upper
    self.keys.each do |key|
      camelized = key.to_s.camelize(c)
      self[camelized] = self.delete(key)
    end
    self
  end

  # Deeply camelize a Hash.
  def deep_camelize_keys c = :upper
    self.dup.deep_camelize_keys!(c)
  end

  # Destructively deeply camelize a Hash.
  def deep_camelize_keys! c = :upper
    self.camelize_keys!(c).keys.each do |k|
      v = self[k]
      self[k] = if v.is_a? Hash
        v.deep_camelize_keys(c)
      else
        v
      end
    end
    self
  end

  # Camelize keys and merge.
  def camel_merge(hash, c = :upper)
    self.dup.camel_merge!(hash, c)
  end

  # In-place camel_merge.
  def camel_merge!(hash, c = :upper)
    self.camelize_keys!(c).merge!(hash.camelize_keys(c))
  end

  # Return a new Hash with all keys converted to underscored Strings.
  def underscore_keys
    inject(self.class.new) do |options, (key, value)|
      options[key.to_s.underscore] = value
      options
    end
  end

  # Destructively convert all keys to underscored Strings.
  def underscore_keys!
    self.keys.each do |key|
      underscored = key.to_s.underscore
      self[underscored] = self.delete(key)
    end
    self
  end

  # Underscore keys and merge.
  def underscore_merge(hash)
    self.dup.underscore_merge!(hash)
  end

  # In-place underscore_merge.
  def underscore_merge!(hash)
    self.underscore_keys!.merge!(hash.underscore_keys)
  end

  # Deeply underscoreize a Hash.
  def deep_underscore_keys
    self.dup.deep_underscore_keys!
  end

  # Destructively deeply underscoreize a Hash.
  def deep_underscore_keys!
    self.underscore_keys!.keys.each do |k|
      v = self[k]
      self[k] = if v.is_a? Hash
        v.deep_underscore_keys
      else
        v
      end
    end
    self
  end

  # Creates an autovivified Hash.
  def self.autonew(*args)
    vivifier = proc { |h, k| h[k] = self.new(&vivifier) }
    self.new(*args, &vivifier)
  end

  # Returns a Hash minus any nil values.
  def compact
    self.dup.compact!
  end

  # In-place compact.
  def compact!
    self.reject! { |k, v| v.nil? }
    self
  end

  # Deeply compact a Hash.
  def deep_compact
    self.dup.deep_compact!
  end

  # Destructively deeply underscoreize a Hash.
  def deep_compact!
    self.compact!.keys.each do |k|
      v = self[k]
      self[k] = if v.is_a? Hash
        v.deep_compact
      else
        v
      end
    end
    self
  end

  # Returns all keys in a Hash, recursively descending through the Hash.
  def deep_keys
    ret = []
    injector = proc { |k, v|
      ret << k
      if v.is_a?(Hash)
        v.each(&injector)
      end
    }
    self.each(&injector)
    ret
  end

  # Returns all values in a Hash, recursively descending through the Hash.
  def deep_values
    ret = []
    injector = proc { |k, v|
      ret << v
      if v.is_a?(Hash)
        v.each(&injector)
      end
    }
    self.each(&injector)
    ret
  end

  # Deeply strip all whitespace destructively.
  def deep_strip!
    self.keys.each do |key|
      value = self[key]
      if value.respond_to?(:deep_strip!)
        value.deep_strip!
      elsif value.respond_to?(:strip!)
        value.strip!
      end
    end
    self
  end

  # Deeply strip all whitespace destructively.
  def deep_strip
    ret = {}
    self.each do |key, value|
      value = self[key]
      ret[key] = if value.respond_to?(:deep_strip)
        value.deep_strip
      elsif value.respond_to?(:strip)
        value.strip
      else
        value
      end
    end
    ret
  end
end
