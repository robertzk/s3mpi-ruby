require 'spec_helper'

module S3MPI

  describe Interface do

    let(:bucket) { 'some_bucket' }
    let(:path) { 'some_folder' }
    let(:csv_file_path) {'spec/support/test.csv'}
    let(:csv_as_array_of_hashes) {
      [
        {'user_id' => 1, 'email' => 'user1@test.com'},
        {'user_id' => 2, 'email' => 'user2@test.com'},
        {'user_id' => 3, 'email' => 'user3@test.com'},
      ]
    }

    subject { described_class.new(bucket: bucket, path: path ) }

    describe '.store_csv' do
      it 'sends the CSV as a row of hashes to .store' do
        expect(subject).to receive(:store).with(csv_as_array_of_hashes)

        subject.store_csv csv_file_path
      end
    end

  end

end
