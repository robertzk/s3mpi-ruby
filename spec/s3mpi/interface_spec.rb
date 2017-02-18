require 'spec_helper'

describe S3MPI::Interface do
  let(:bucket) { 'some_bucket' }
  let(:path)   { 'some_folder' }

  let(:interface) { described_class.new(bucket, path) }

  describe '#bucket' do
    subject{ interface.bucket }
    it { is_expected.to be_a AWS::S3::Bucket }
    it { is_expected.to have_attributes(name: bucket) }
  end

  describe '#path' do
    subject{ interface.path }
    it { is_expected.to eql path }
  end

  describe '#exists?' do

  end

  describe '#s3_object' do

  end

  describe '#converter' do

  end

  describe '#read' do

  end

  describe '#store' do

  end

  #before{ AWS.stub! }

end
