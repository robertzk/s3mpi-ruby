require 's3mpi/s3'
require 's3mpi/converters'

module S3MPI
  class Interface
    include S3
    include Converters

    UUID = Object.new.freeze

    # Return S3 bucket under use.
    #
    # @return [AWS::S3::Bucket]
    attr_reader :bucket

    # Return S3 path under use.
    #
    # @return [String]
    attr_reader :path

    # Return the default converter for store & read.
    #
    # @return [String]
    attr_reader :default_converter

    # Create a new S3MPI object that responds to #read and #store.
    #
    # @return [S3MPI::Interface]
    #
    # @api public
    def initialize bucket, path = '', default_converter = :json
      @bucket = parse_bucket(bucket)
      @path   = path.freeze
      converter(default_converter) # verify it is valid
      @default_converter = default_converter
    end

    # Store a Ruby object in an S3 bucket.
    #
    # @param [Object] obj
    #    Any convertable Ruby object (usually a hash or array).
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    # @param [Symbol] :as
    #    Which converter to use e.g. :json, :csv, :string
    # @param [Integer] tries
    #    The number of times to attempt to store the object.
    def store(obj, key = UUID, as: default_converter, tries: 1)
      key = SecureRandom.uuid if key.equal?(UUID)
      s3_object(key).put(body: converter(as).generate(obj))
    rescue Aws::Errors => e
      tries -= 1
      if tries > 0
        retry
      else
        raise(e)
      end
    end

    def store_csv(obj, key = UUID); store(obj, key, as: :csv); end
    def store_json(obj, key = UUID); store(obj, key, as: :json); end
    def store_string(obj, key = UUID); store(obj, key, as: :string); end

    # Read and de-serialize an object from an S3 bucket.
    #
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    # @param [Symbol] :as
    #    Which converter to use e.g. :json, :csv, :string
    def read(key = nil, as: default_converter)
      converter(as).parse(s3_object(key).get.body.read)
    rescue Aws::S3::Errors::NoSuchKey
      nil
    end

    def read_csv(key = nil); read(key, as: :csv); end
    def read_json(key = nil); read(key, as: :json); end
    def read_string(key = nil); read(key, as: :string); end

    # Check whether a key exists for this MPI interface.
    #
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    #
    # @return [TrueClass,FalseClass]
    def exists?(key)
      s3_object(key).exists?
    end

  end
end
