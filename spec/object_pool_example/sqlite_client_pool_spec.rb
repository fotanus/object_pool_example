require 'spec_helper'

module ObjectPoolExample
  describe SQLiteClientPool do
    database_path = "spec/test.sqlite"
    before(:each) {
      File.delete database_path if File.exists?(database_path)
      stub_const(
        "ObjectPoolExample::SQLiteClient::DATABASE_PATH",
        database_path
      )
    }

    describe ".instance" do
      subject { SQLiteClientPool }
      it "Recovers the pool instance" do
        expect(subject.instance).to be_kind_of(SQLiteClientPool)
      end

      it "Always recover the same pool instance" do
        i1 = subject.instance
        i2 = subject.instance
        expect(i1).to be i2
      end
    end

    describe "#acquire_sqlite_client" do
      subject { SQLiteClientPool.instance }
      it "Recovers a sqlite client client" do
        expect(subject.acquire_sqlite_client).to be_kind_of(SQLiteClient)
      end
    end

    describe "#release_sqlite_client" do
      subject { SQLiteClientPool.instance }
      let(:client) { subject.acquire_sqlite_client }

      it "Returns one sqlite client" do
        expect{
          subject.release_sqlite_client(client)
        }.to change {
          subject.instance_variable_get(:@objects).count
        }.by(1)
      end
    end
  end
end
