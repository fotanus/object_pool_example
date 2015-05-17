require "sqlite3"

module ObjectPoolExample
  class SQLiteClient

    DATABASE_PATH = "/tmp/object_pool_example.sqlite"
    def initialize
      @db = SQLite3::Database.new DATABASE_PATH
    end

    def execute(sql, &block)
      if block_given?
        @db.execute sql, &block
      else
        @db.execute sql
      end
    end
  end
end
