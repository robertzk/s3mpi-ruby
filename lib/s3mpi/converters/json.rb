require 'json'

module S3MPI
  module Converters
    module JSON
      extend self

      def parse(json_string, options = Hash.new)
        opts = { quirks_mode: true }.merge(options)
        ::JSON.parse(json_string || 'null', **opts)
      end

      def generate(object, options = Hash.new)
        object.to_json(options)
      end

    end
  end
end
