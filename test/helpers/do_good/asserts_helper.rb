# encoding: UTF-8

module DoGood::AssertsHelper
  def assert_same_contents(expected, actual, msg = nil)
    assert same_elements?(expected, actual), msg || "#{expected} did not have the same elements as #{actual}"
  end

  def assert_same_contents_different_order(expected, actual, msg = nil)
    assert_same_contents(expected, actual)
    found_difference_in_order = expected.each_with_index.collect { |x, i|
      actual[i] == x
    }.find(false)

    assert found_difference_in_order, msg || "#{expected} and #{actual} are in the same order"
  end

  def same_elements?(array_one, array_two)
    ((array_one - array_two) + (array_two - array_one)).empty?
  end

  def assert_or_refute_where_values_equal(assert_or_refute, expected, scope_or_hash, msg = nil)
    where_values_hash = case scope_or_hash
      when Hash
        scope_or_hash
      when ActiveRecord::Base, ActiveRecord::Relation
        scope_or_hash.where_values_hash
      else
        raise ArgumentError.new("Expected a scope or a Hash")
    end

    send("#{assert_or_refute}_equal", expected, where_values_hash, msg)
  end

  def assert_where_values_equal(expected, scope_or_hash, msg = nil)
    msg ||= "Expected where_values_hash to match"
    assert_or_refute_where_values_equal(:assert, expected, scope_or_hash, msg)
  end

  def refute_where_values_equal(expected, scope_or_hash, msg = nil)
    msg ||= "Expected where_values_hash not to match"
    assert_or_refute_where_values_equal(:refute, expected, scope_or_hash, msg)
  end

  def assert_hashes_equal(expected, hash, msg = nil)
    assert_equal(Hash[expected.sort], Hash[hash.sort], msg)
  end

  def refute_hashes_equal(expected, hash, msg = nil)
    refute_equal(Hash[expected.sort], Hash[hash.sort], msg)
  end

  def assert_instances_of(klass, objects, msg = nil)
    Array.wrap(objects).each_with_index do |object, i|
      assert_instance_of(klass, object, msg || proc {
        "Expected objects[#{i}] to be an instance of #{klass}, not #{object.class}"
      })
    end
  end

  def refute_instances_of(klass, objects, msg = nil)
    Array.wrap(objects).each_with_index do |object, i|
      refute_instance_of(klass, object, msg || proc {
        "Expected objects[#{i}] to not be an instance of #{klass}"
      })
    end
  end

  def assert_cacheable_table_row_not_found
    assert_raises(DoGood::ActiveRecord::CacheableReferenceTable::RowNotFound) do
      yield
    end
  end

  def refute_cacheable_table_row_not_found
    refute_raises(Zoocasa::ActiveRecord::CacheableReferenceTable::RowNotFound) do
      yield
    end
  end

  def assert_instances_of(klass, objects, msg = nil)
    Array.wrap(objects).each_with_index do |object, i|
      assert_instance_of(klass, object, msg || proc {
        "Expected objects[#{i}] to be an instance of #{klass}, not #{object.class}"
      })
    end
  end

  def refute_instances_of(klass, objects, msg = nil)
    Array.wrap(objects).each_with_index do |object, i|
      refute_instance_of(klass, object, msg || proc {
        "Expected objects[#{i}] to not be an instance of #{klass}"
      })
    end
  end

  def assert_cacheable_table_row_not_found
    assert_raises(Zoocasa::ActiveRecord::CacheableReferenceTable::RowNotFound) do
      yield
    end
  end

  def refute_cacheable_table_row_not_found
    refute_raises(Zoocasa::ActiveRecord::CacheableReferenceTable::RowNotFound) do
      yield
    end
  end

  def assert_presence(value, msg = nil)
    assert(value.present?, msg || "Expected #{value} to be present")
  end

  def refute_presence(value, msg = nil)
    refute(value.present?, msg || "Expected #{value} to not be present")
  end

  def assert_blank(value, msg = nil)
    assert(value.blank?, msg || "Expected #{value} to be blank")
  end

  def refute_blank(value, msg = nil)
    refute(value.blank?, msg || "Expected #{value} to not be blank")
  end
end

