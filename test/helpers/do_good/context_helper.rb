
module DoGood::ContextHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def context(*name, &block)
      subclass = Class.new(self)
      @context_subclasses ||= []
      @context_subclasses << subclass
      remove_tests(subclass)
      subclass.class_eval(&block) if block_given?
      const_set(context_name(name.join(" ")), subclass)
    end

    def test(name, &block)
      method_name = test_name(name)

      # When adding new methods to a context's parent context, avoiding adding
      # them to any context subclasses via inheritance. Note that a subcontext
      # can have its own test called "name"; don't undefine it.
      contexts_without_matching_test_name = (@context_subclasses || []).reject do |context|
        context.instance_methods.include?(method_name.to_s)
      end

      define_method(method_name, &block)
      contexts_without_matching_test_name.each { |subclass| subclass.send(:undef_method, method_name) }
    end

    def xcontext(*args)
      # no-op
    end

    def xtest(*args)
      # no-op
    end

    private
      def context_name(name)
        "Test#{sanitize_name_fully(name).gsub(/(^| )(\w)/) { $2.upcase }}".to_sym
      end

      def test_name(name)
        "test #{name}".to_sym
      end

      def sanitize_name_fully(name)
        name.gsub(/\W+/, ' ').strip
      end

      def sanitize_name(name)
        name.gsub(/[^\w?!=]+/, ' ').strip
      end

      def remove_tests(subclass)
        subclass.public_instance_methods.grep(/^test /).each do |meth|
          subclass.send(:undef_method, meth.to_sym)
        end
      end
  end
end

