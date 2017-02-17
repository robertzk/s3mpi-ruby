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

      # Convert an array of hashes to CSV string data
      #
      # @param [Array] array_of_hashes
      #    An Array of Hashes
      #
      # @param [Hash] options
      #    Passed to CSV.generate
      def generate(array_of_hashes, options = Hash.new)
        CSV.generate(options) do |csv|
          array_of_hashes.each{ |h| csv << h }
        end
      end

    end
  end
end
