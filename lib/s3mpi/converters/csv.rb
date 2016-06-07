require 'csv'

module S3MPI
  module Converters
    module CSV
      extend self

      # Read a CSV file and convert it to an array of hashes
      #
      # @param [String] csv_file_path
      #    Path to the CSV file.
      #
      # @param [Hash] options
      #    Passed to CSV.parse
      def file_to_obj(csv_file_path, options = Hash.new)
        csv_data = File.read(csv_file_path)
        string_to_obj(csv_data, options)
      end

      # Convert CSV string data to an array of hashes
      #
      # @param [String] csv_data
      #    String of CSV data
      #
      # @param [Hash] options
      #    Passed to CSV.parse
      def string_to_obj(csv_data, options = Hash.new)
        options = options.merge({
                                  headers:    true,
                                  converters: :all

                                })
        ::CSV.parse(csv_data, options).map(&:to_hash)
      end
    end
  end
end