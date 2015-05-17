require "singleton"

module ObjectPoolExample
  class SQLiteClientPool
    include Singleton

    def initialize
      @objects = []
    end

    def acquire_sqlite_client
      if @objects.empty?
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
