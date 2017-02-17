require 'spec_helper'

describe S3MPI::Converters::CSV do
  let(:csv_file_path) { 'spec/support/test.csv' }
  let(:csv_data_string) { File.read csv_file_path }

  let(:csv_as_array_of_hashes) {
    [
      {'integer' => 1, 'string' => 'user1@test.com', 'float' => 1.11},
      {'integer' => 2, 'string' => 'user2@test.com', 'float' => 2.22},
      {'integer' => 3, 'string' => 'user3@test.com', 'float' => 3.33},
    ]
  }

  describe '#string_to_obj' do
    subject { described_class.string_to_obj csv_data_string }

    it_behaves_like 'a parsed CSV'

    it { is_expected.to eql csv_as_array_of_hashes }
  end

  describe '#file_to_obj' do
    subject { described_class.file_to_obj csv_file_path }

    it_behaves_like 'a parsed CSV'

    it { is_expected.to eql csv_as_array_of_hashes }
  end
end
