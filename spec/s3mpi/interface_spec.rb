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

  describe '#converter' do
    def expect_converter(key, klass)
      expect(interface.converter(key)).to eql klass
    end

    it('json'){ expect_converter :json, S3MPI::Converters::JSON }
    it('csv') { expect_converter :csv,  S3MPI::Converters::CSV  }
    it('string'){ expect_converter :string, S3MPI::Converters::Identity }
    it('identity'){ expect_converter :identity, S3MPI::Converters::Identity }

    it "raises for unknown keys" do
      err = S3MPI::Converters::UnknownConverterError
      msg = ":foo is not a known converter!"
      expect{ interface.converter(:foo) }.to raise_error(err, msg)
    end
  end

  describe '#s3_object' do

  end

  describe '#exists?' do

  end

  describe '#read' do

  end

  describe '#store' do

  end

  #before{ AWS.stub! }

end
