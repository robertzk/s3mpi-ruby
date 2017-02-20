require 'aws-sdk-v1'

module S3MPI
  module S3

    def s3_object(name)
      bucket.objects[full_object_key(name)]
    end

    private

    def parse_bucket(bucket)
      AWS::S3.new.buckets[bucket]
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
