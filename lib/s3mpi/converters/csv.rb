require 'csv'

module S3MPI
  module Converters
    module CSV
      extend self

      # Convert CSV string data to an array of hashes
      #
      # @param [String] csv_data
      #    String of CSV data
      #
      # @param [Hash] options
      #    Passed to CSV.parse
      def parse(csv_data, options = Hash.new)
        options = options.merge({
                                  headers:    true,
                                  converters: :all
                                })
        ::CSV.parse(csv_data, options).map(&:to_hash)
      end

    end
  end
end
