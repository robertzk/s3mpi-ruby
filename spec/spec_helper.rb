# encoding: utf-8
require 's3mpi'

RSpec.configure do |config|
  Aws.config.merge!(region: 'us-east-1', credentials: Aws::Credentials.new('keyid', 'secret'))
end
