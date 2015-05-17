$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'object_pool_example'

def populate_db(sqlite_client)
  sqlite_client.execute "create table numbers ( name varchar(30), val int);"
  sqlite_client.execute "insert into numbers (name, val) values ('one', 1);"
  sqlite_client.execute "insert into numbers (name, val) values ('two', 2);"
end
