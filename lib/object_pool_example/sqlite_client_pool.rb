require "singleton"

module ObjectPoolExample
  class SQLiteClientPool
    include Singleton

    def initialize
      @objects = []
      @objects_created = 0
    end

    def acquire_sqlite_client
      if @objects.empty?
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
