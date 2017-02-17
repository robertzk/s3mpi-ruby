module S3MPI
  module Converters
    module Identity
      extend self

      def parse(data, options = nil)
        data
      end

      def generate(data)
        data
      end

    end
  end
end
