# encoding: UTF-8

require 'test_cases/do_good/active_record/extensions'

class DoGood::ActiveRecordTestCase < ActiveRecord::TestCase
  include DoGood::TestHelper
  include DoGood::ARBCHelper
  include DoGood::AssertsHelper
  include DoGood::ContextHelper
  include DoGood::Testing::TaggedLogging

  def teardown
    super

    Rails.cache.clear
    Timecop.return
  end

  def refute_sql(*patterns_to_match)
    ActiveRecord::SQLCounter.log = []
    yield
    ActiveRecord::SQLCounter.log
  ensure
    successful_patterns = []
    patterns_to_match.each do |pattern|
      successful_patterns << pattern if ActiveRecord::SQLCounter.log.any? { |sql| pattern === sql }
    end

    assert successful_patterns.empty?, "Query pattern(s) #{successful_patterns.map{ |p| p.inspect }.join(', ')} were found but shouldn't have been.#{ActiveRecord::SQLCounter.log.size == 0 ? '' : "\nQueries:\n#{ActiveRecord::SQLCounter.log.join("\n")}"}"
  end
end
