module Ruby
  module CoreExtensions
    module Nullable
      attr_accessor :values

      def self.included(base)
        # We can't override #respond_to? directly in the class, strangely
        # enough.
        base.send(:define_method, :respond_to?) do |*args|
          true
        end
      end

      def initialize(values = {})
        @values = values
      end

      def method_missing(name, *args, &block)
        if self.values.has_key?(name)
          value = self.values[name]

          if value.respond_to?(:call)
            self.instance_eval(&value)
          else
            value
          end
        else
          self
        end
      end

      def nil?
        true
      end
      alias :blank? :nil?
      alias :empty? :nil?

      if RUBY_VERSION >= '1.9'
        alias :'!' :nil?
      end

      def present?
        false
      end

      def to_a
        []
      end
      alias :to_ary :to_a

      def to_s
        ''
      end

      def to_f
        0.0
      end

      def to_i
        0
      end

      def inspect
        "#<%s:0x00%s%s>" % [
          self.class.name,
          (self.object_id << 1).to_s(16),
          !self.values.empty? ?
            " values=#{self.values.inspect}" :
            ''
        ]
      end
    end

    class NullObject
      include Nullable
    end
  end
end

