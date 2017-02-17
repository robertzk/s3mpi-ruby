require 'spec_helper'

describe S3MPI::Interface do
  let(:bucket) { 'some_bucket' }
  let(:path) { 'some_folder' }
  let(:csv_file_path) { 'spec/support/test.csv' }
  let(:csv_data_string) { File.read csv_file_path }
  let(:csv_as_array_of_hashes) {
    [
      {'integer' => 1, 'string' => 'user1@test.com', 'float' => 1.11},
      {'integer' => 2, 'string' => 'user2@test.com', 'float' => 2.22},
      {'integer' => 3, 'string' => 'user3@test.com', 'float' => 3.33},
    ]
  }
  let(:interface) { described_class.new(bucket: bucket, path: path) }
  subject { interface }
  describe '.store_csv' do
    it 'sends the CSV as a row of hashes to .store' do
      expect(subject).to receive(:store).with(csv_as_array_of_hashes)

      subject.store_csv csv_file_path
    end
  end

  describe '.read_csv' do

    before { allow(interface).to receive(:s3_object) { double(read: csv_data_string) } }
    subject { interface.read_csv csv_file_path }
    it_behaves_like 'a parsed CSV'

  end
end
