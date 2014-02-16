# encoding: UTF-8

module ActiveRecord
  class SQLCounter
    cattr_accessor :ignored_sql
    self.ignored_sql = [
      /^PRAGMA (?!(table_info))/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/,
      /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/,
      /^SHOW max_identifier_length/, /^BEGIN/, /^COMMIT/, /^ROLLBACK/, /\WFROM pg_/
    ]

    cattr_accessor :log
    self.log = []

    attr_reader :ignore

    def initialize(ignore = self.class.ignored_sql)
      @ignore   = ignore
    end

    def call(name, start, finish, message_id, values)
      sql = values[:sql]

      # FIXME: this seems bad. we should probably have a better way to indicate
      # the query was cached
      return if 'CACHE' == values[:name] || ignore.any? { |x| x =~ sql }
      self.class.log << sql
    end
  end

  ActiveSupport::Notifications.subscribe('sql.active_record', SQLCounter.new)
end

