require 'spec_helper'

module S3MPI
  module Converters
    describe CSV do

      let(:csv_file_path) { 'spec/support/test.csv' }
      let(:csv_data_string) { File.read csv_file_path }

      describe '#convert_to_obj' do
        subject { described_class.string_to_obj csv_data_string }

        it_behaves_like 'a parsed CSV'
      end

      describe '#file_to_obj' do
        subject { described_class.file_to_obj csv_file_path }

        it_behaves_like 'a parsed CSV'

      end
    end
  end
end
