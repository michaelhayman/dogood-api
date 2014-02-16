# encoding: UTF-8

module DoGood::FooTestsHelper
  extend ActiveSupport::Concern
  extend DoGood::ARBCHelper

  included do
    @base = self

    self.class_eval do
      extend DoGood::ARBCHelper
    end
  end

  module ClassMethods
    attr_reader :foo

    def build_foos_class
      self.destroy_foos_class
      @foo = Class.new(ActiveRecord::Base)
      @base.const_set(:Foo, @foo)
      @foo.reset_column_information
    end

    def destroy_foos_class
      if @base.const_defined?(:Foo)
        @base.send(:remove_const, :Foo)
      end
    end

    def create_foos_table
      arbc.create_table(:foos) do |t|
        if block_given?
          yield t
        else
          t.text :name
          t.timestamps
        end
      end
    end

    def drop_foos_table
      arbc.drop_table(:foos, :if_exists => true)
    end

    def before_suite
      self.drop_foos_table
      self.create_foos_table
      self.build_foos_class
    end

    def after_suite
      self.drop_foos_table
      self.destroy_foos_class
    end
  end
end

