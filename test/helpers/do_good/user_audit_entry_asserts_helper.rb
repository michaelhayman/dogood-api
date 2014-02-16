# encoding: UTF-8

module DoGood::UserAuditEntryAssertsHelper
  def assert_audit_entry expected_entry, actual
    if actual.nil?
      refute_nil actual, "there was no entry given"
    end

    equal_results = expected_entry.collect do |key, value|
      actual.send(key) == value
    end

    assert equal_results.select { |value| !value }.empty?, "Expected audit_entry #{expected_entry} but got #{actual.attributes}"
  end
end
