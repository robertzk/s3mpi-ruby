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
        return "" if array_of_hashes.empty?
        headers = inspect_headers(array_of_hashes)
        ::CSV.generate(options) do |csv|
          csv << headers
          array_of_hashes.each do |hash|
            csv << hash.values_at(*headers)
          end
        end
      end

      private

      class HeaderError < StandardError; end

      def inspect_headers(data)
        data.first.keys.tap do |headers|
          sorted = headers.sort
          error  = data.any?{ |hash| hash.keys.sort != sorted }
          raise HeaderError, "the rows have inconsistent headers!" if error
        end
      end

    end
  end
end
