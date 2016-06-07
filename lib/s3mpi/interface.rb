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
    def initialize _bucket, path = ''
      @bucket = _bucket
      @path   = path
    end

    # Store a Ruby object in an S3 bucket.
    # 
    # @param [Object] obj
    #    Any JSON-serializable Ruby object (usually a hash or array).
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    # @param [Integer] try
    #    The number of times to attempt to store the object.
    def store(obj, key = SecureRandom.uuid, try = 1)
      s3_object(key).write(obj.to_json)
    rescue # This should really rescue specific errors
      (try -= 1) > 0 ? retry : raise
    end


    # Load a CSV file, and store the contents in S3
    # Proxies to store
    #
    # @param [String] csv_file_path
    #     Path to the CSV file.
    #
    # @param [Hash] options Options hash.
    #    Passed to CSV.parse
    def store_csv(csv_file_path, options = Hash.new)
      store(Converters::CSV.file_to_obj(csv_file_path, options))
    end

    # Store a raw object
    # @param [Object] obj
    #    The object to store.
    # @param [String] key
    #    The key under which the object is saved in the S3 bucket.
    def store_raw(obj, key)
      s3_object(key).write(obj)
    end

    # Read a JSON-serialized Ruby object from an S3 bucket.
    # 
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    def read key = nil
      parse_json_allowing_quirks_mode s3_object(key).read
    rescue AWS::S3::Errors::NoSuchKey
      nil
    end

    # Read a CSV file from an S3 bucket. Return as array of hashes.
    #
    # @param [String] key
    #    The key under which the file is saved in the S3 bucket.
    def read_csv(key=nil)
      Converters::CSV.string_to_obj(s3_object(key).read)
    rescue AWS::S3::Errors::NoSuchKey
      nil
    end

    # Check whether a key exists for this MPI interface.
    # 
    # @param [String] key
    #    The key under which to save the object in the S3 bucket.
    #    
    # @return [TrueClass,FalseClass]
    def exists?(key)
      s3_object(key).exists?
    end

    # Fetch the S3 object as an AWS::S3::S3Object.
    # 
    # @param [String] name
    #    The key under which to save the object in the S3 bucket.
    #    
    # @return [AWS::S3::S3Object]
    def object(key)
      AWS::S3::S3Object.new(bucket, "#{@path}#{key}")
    end

    def bucket
      @_bucket ||= parse_bucket @bucket
    end
  end
end

    
