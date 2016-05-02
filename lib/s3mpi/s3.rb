require 'aws-sdk-v1'

module S3MPI
  module S3

    def parse_bucket(bucket) 
      AWS::S3.new.buckets[bucket]
    end

    def s3_object name
      bucket.objects[[path, name].join('/')]
    end

  end
end
