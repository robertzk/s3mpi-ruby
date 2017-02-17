require 'json'

module S3MPI
  module Converters
    module JSON
      extend self

      def parse(data, options = Hash.new)
        opts = { quirks_mode: true }.merge(options)
        ::JSON.parse(data || 'null', **opts)
      end

    end
  end
end
