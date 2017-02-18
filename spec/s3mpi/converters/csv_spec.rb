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

  describe '#parse' do
    subject { described_class.parse csv_data_string }

    it 'converts CSV data to an array of hashes' do
      expect(subject).to be_kind_of Array

      subject.each do |row|
        expect(row).to be_kind_of Hash
      end
    end

    it 'preserves integers' do
      subject.each do |row|
        expect(row['integer']).to eq(row['integer'].to_s.to_i)
      end
    end

    it 'preserves floats' do
      subject.each do |row|
        expect(row['float']).to eq(row['float'].to_s.to_f)
      end
    end

    it { is_expected.to eql csv_as_array_of_hashes }
  end

  describe '#generate' do
    subject { described_class.generate csv_as_array_of_hashes }

    it { is_expected.to eql csv_data_string }
  end
end
