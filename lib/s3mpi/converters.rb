require 's3mpi/converters/csv'
require 's3mpi/converters/json'
require 's3mpi/converters/identity'

module S3MPI
  module Converters

    class UnknownConverterError < StandardError; end

    def converter(as)
      case as
      when :json then Converters::JSON
      when :csv  then Converters::CSV
      when :string, :identity then Converters::Identity
      else
        raise UnknownConverterError, "#{as.inspect} is not a known converter!"
      end
    end

  end
end
