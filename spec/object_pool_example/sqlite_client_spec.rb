require 'spec_helper'

module ObjectPoolExample
  describe SQLiteClient do
    before(:each) { reset_test_database }

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
