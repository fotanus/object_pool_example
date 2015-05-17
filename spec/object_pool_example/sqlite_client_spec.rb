require 'spec_helper'

module ObjectPoolExample
  describe SQLiteClient do
    database_path = "spec/test.sqlite"
    before(:each) {
      File.delete database_path if File.exists?(database_path)
      stub_const(
        "ObjectPoolExample::SQLiteClient::DATABASE_PATH",
        database_path
      )
    }

    describe "#initialize" do
      it "Creates a connection on instanciate" do
        expect(SQLite3::Database).to receive(:new)
        SQLiteClient.new
      end
    end

    describe "#execute" do
      subject { SQLiteClient.new }
      it "Execute a SQL query" do
        subject.execute "create table numbers ( name varchar(30), val int);"
      end

      it "receive a block for select" do
        populate_db(subject)
        expect { |b|
          subject.execute "select * from numbers", &b
        }.to yield_control.twice
      end
    end
  end
end
