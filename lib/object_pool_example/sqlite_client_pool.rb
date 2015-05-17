require "singleton"
require "thread"

module ObjectPoolExample
  class SQLiteClientPool
    include Singleton

    MAX_OBJECTS = 4
    def initialize
      @objects = Queue.new
      @objects_created = 0
    end

    def acquire_sqlite_client
      if @objects.empty? and @objects_created < MAX_OBJECTS
        @objects_created += 1
        SQLiteClient.new
      else
        @objects.pop
      end
    end

    def release_sqlite_client(client)
      @objects << client
    end
  end
end
