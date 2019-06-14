require 'aws-sdk-s3'

module S3MPI
  module S3

    def s3_object(name)
      bucket.object(full_object_key(name))
    end

    private

    def parse_bucket(bucket)
      Aws::S3::Resource.new.bucket(bucket)
    end

    def full_object_key(name)
      [path, name].flatten.reject{ |x| blank?(x) }.join('/')
    end

    def blank?(x)
      return true if !x
      return true if x.is_a?(String) && x.strip == ""
      false
    end

  end
end
