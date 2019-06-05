# -*- encoding: utf-8 -*-
require './lib/s3mpi/version'

Gem::Specification.new do |s|
  s.name        = 's3mpi'
  s.version     = S3MPI::VERSION::STRING.dup
  s.date        = Date.today.to_s
  s.summary     = 'Upload and download files to S3 using a very convenient API.'
  s.description = %(Passing objects between Ruby consoles can be cumbersome if the
                    user has performed some serialization and deserialization procedure.
                    S3MPI aims to enable simple reading and writing to S3 buckets
                    without the typical overhead of the AWS gem.
  ).strip.gsub(/\s+/, " ")
  s.authors     = ["Robert Krzyzanowski"]
  s.email       = 'rkrzyzanowski@gmail.com'
  s.homepage    = 'http://github.com/robertzk'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/robertzk/s3mpi-ruby'

  s.platform = Gem::Platform::RUBY
  s.require_paths = %w[lib]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_runtime_dependency 'aws-sdk-s3', '~> 1'

  s.add_development_dependency 'rake', '~> 10.1.0'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'pry', '~> 0.10.4'

  s.extra_rdoc_files = ['README.md', 'LICENSE']
end
