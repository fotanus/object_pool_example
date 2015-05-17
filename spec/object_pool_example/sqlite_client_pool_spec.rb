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

      describe "On first call" do
        it "creates a sqlite client client" do
          expect(subject.acquire_sqlite_client).to be_kind_of(SQLiteClient)
        end

        it "increments the object counter" do
          expect{
            subject.acquire_sqlite_client
          }.to change {
            subject.instance_variable_get(:@objects_created)
          }.by(1)
        end
      end

      describe "If has an object on the queue" do
        let(:client) { subject.acquire_sqlite_client}
        before(:each) { subject.release_sqlite_client(client) }

        it "Gives that object" do
          expect(subject.acquire_sqlite_client).to be client
        end

        it "Won't create a new client" do
          expect{
            subject.acquire_sqlite_client
          }.to_not change {
            subject.instance_variable_get(:@objects_created)
          }
        end
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
