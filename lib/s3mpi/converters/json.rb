require 'json'

module S3MPI
  module Converters
    module JSON
      extend self

      def parse(data)
        ::JSON.parse(data || 'null', quirks_mode: true)
      end

    end
  end
end
