require 'json'
require 's3mpi/format'
require 's3mpi/s3'
require 's3mpi/converters'

module S3MPI
  class Interface
    include Format
    include S3

    # Return S3 bucket under use.
    #
    # @return [AWS::S3::Bucket]
    attr_reader :bucket

    # Return S3 path under use.
    #
    # @return [String]
    attr_reader :path

    # Create a new S3MPI object that responds to #read and #store.
    #
    # @return [S3MPI::Interface]
    #
    # @api public
    def initialize bucket, path = ''
      @bucket = parse_bucket(bucket)
      @path   = path.freeze
    end

    # Store a Ruby object in an S3 bucket.
    #
    # @param [Object] obj
    #    Any JSON-serializable Ruby object (usually a hash or array).
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    # @param [Integer] tries
    #    The number of times to attempt to store the object.
    def store(obj, key = SecureRandom.uuid, tries: 1)
      store_string(obj.to_json, key, tries: tries)
    end

    # Store a raw string to S3
    # @param [String] string
    #    The string to store.
    # @param [String] key
    #    The key under which the object is saved in the S3 bucket.
    # @param [Integer] :tries
    #    The number of times to attempt to store the object.
    def store_string(string, key, tries: 1)
      s3_object(key).write(string)
    rescue AWS::Errors::ServerError
      (tries -= 1) > 0 ? retry : raise
    end
    alias_method :store_raw, :store_string

    # Load a CSV file, and store the contents in S3
    # Proxies to store
    #
    # @param [String] csv_file_path
    #     Path to the CSV file.
    #
    # @param [Hash] options Options hash.
    #    Passed to CSV.parse
    def store_csv(csv_file_path, options = Hash.new)
      csv_string = Converters::CSV.file_to_obj(csv_file_path, options)
      store_string(csv_string, SecureRandom.uuid)
    end

    # Read a JSON-serialized Ruby object from an S3 bucket.
    #
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    def read key = nil
      parse_json_allowing_quirks_mode(read_string(key))
    end

    # Read a CSV file from an S3 bucket. Return as array of hashes.
    #
    # @param [String] key
    #    The key under which the file is saved in the S3 bucket.
    def read_csv(key=nil)
      Converters::CSV.string_to_obj(read_string(key))
    end

    def read_string(key = nil)
      s3_object(key).read
    rescue AWS::S3::Errors::NoSuchKey
      nil
    end
    alias_method :read_raw, :read_string

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
