
ENV["RAILS_ENV"] = "test"
$: << File.dirname(__FILE__)

require 'simplecov'

SimpleCov.command_name('Unit Tests')
SimpleCov.start 'rails' do
  add_filter '/test/'
  add_filter '/.bundle/'

  add_group 'Decorators', 'app/decorators'
  add_group 'Form Models', 'app/form_models'
  add_group 'Workers', 'app/workers'
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/reporters'

require 'helpers/do_good/context_helper'
require 'helpers/do_good/arbc_helper'

class DoGoodTestRunner < MiniTest::Reporters::SpecReporter
  include DoGood::ARBCHelper

  def before_suite(suite)
    super(suite)
    suite.before_suite if suite.respond_to?(:before_suite)
  end

  def after_suite(suite)
    super(suite)
    suite.after_suite if suite.respond_to?(:after_suite)
  end
end

MiniTest::Reporters.use!(DoGoodTestRunner.new)



