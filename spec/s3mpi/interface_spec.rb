require 'spec_helper'

describe S3MPI::Interface do
  let(:bucket) { 'some_bucket' }
  let(:path)   { 'some_folder' }

  let(:interface) { described_class.new(bucket, path) }

  describe '#bucket' do
    subject { interface.bucket }
    it { is_expected.to be_a Aws::S3::Bucket }
    it { is_expected.to have_attributes(name: bucket) }
  end

  describe '#path' do
    subject { interface.path }
    it { is_expected.to eql path }
  end

  describe '#default_converter' do
    subject { interface.default_converter }

    context 'default' do
      it { is_expected.to eql :json }
    end

    context 'set on initialization to :csv' do
      let(:interface) { described_class.new(bucket, path, :csv) }
      it { is_expected.to eql :csv }
    end

    it "initialization fails if it is invalid" do
      expect{ described_class.new(bucket, path, :foo) }.to raise_error \
        S3MPI::Converters::UnknownConverterError
    end
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
    subject { interface.s3_object(name) }

    let(:name) { 'foo/bar/baz' }

    it { is_expected.to be_a Aws::S3::Object }
    it { expect(subject.bucket).to have_attributes(name: interface.bucket.name) }
    it { is_expected.to have_attributes(key: "#{path}/#{name}") }

    { 'empty' => '', 'whitespace' => '  ', 'nil' => nil }.each do |desc, value|
      context "#{desc} path" do
        let(:path) { value }
        it { is_expected.to have_attributes(key: name) }
      end

      context "#{desc} name" do
        let(:name) { value }
        it { is_expected.to have_attributes(key: path) }
      end
    end
  end

  context "with a pinned s3_object" do
    def pin_s3_objects!
      s3_objects_to_pin.each do |key, s3_obj|
        allow(interface).to receive(:s3_object).with(key).and_return(s3_obj)
      end
    end

    def s3_objects_to_pin(*keys)
      (@to_pin ||= {}).tap do |h|
        keys.each { |k| h[k] = interface.s3_object(k) }
      end
    end

    let(:name) { 'name' }

    before  { s3_objects_to_pin(name) }
    subject { pin_s3_objects! && s3_objects_to_pin[name] }

    describe '#exists?' do
      it 'calls .exists? on the s3 object' do
        expect(subject).to receive(:exists?).and_return(retval = double)
        expect(interface.exists?(name)).to equal retval
      end
    end

    let(:as_json) { '{"a":1,"b":"two","c":[3,3,3]}' }
    let(:as_hash) { { "a" => 1, "b" => "two", "c" => [3,3,3] } }

    let(:as_csv)  { "x,y,z\n1,2,3\n4,5,6\n7,8,9\n" }
    let(:as_list) { [{"x" => 1, "y" => 2, "z" => 3},
                     {"x" => 4, "y" => 5, "z" => 6},
                     {"x" => 7, "y" => 8, "z" => 9}] }

    let(:random_str) { 10.times.map{ SecureRandom.uuid}.join("\n") }

    describe '#read' do
      it 'can parse the raw string with the json converter' do
        expect(subject).to receive(:read).and_return(as_json).twice
        expect(interface.read(name, as: :json)).to eql(as_hash)
        expect(interface.read_json(name)).to eql(as_hash)
      end

      it 'can parse the raw string with the csv converter' do
        expect(subject).to receive(:read).and_return(as_csv).twice
        expect(interface.read(name, as: :csv)).to eql(as_list)
        expect(interface.read_csv(name)).to eql(as_list)
      end

      it 'can parse the raw string with the identity converter' do
        expect(subject).to receive(:read).and_return(random_str).twice
        expect(interface.read(name, as: :identity)).to eql(random_str)
        expect(interface.read_string(name)).to eql(random_str)
      end

      it 'defaults to the default_converter' do
        allow(interface).to receive(:default_converter).and_return(:foo)
        expect(subject).to receive(:read).and_return(as_json)
        expect(interface).to receive(:converter
                        ).with(:foo).and_return(S3MPI::Converters::Identity)
        expect(interface.read(name)).to eql as_json
      end
    end

    describe '#store' do
      it 'can generate json and write it to s3' do
        expect(subject).to receive(:put).with(body: as_json).twice
        interface.store(as_hash, name, as: :json)
        interface.store_json(as_hash, name)
      end

      it 'can generate csv and write it to s3' do
        expect(subject).to receive(:put).with(body: as_csv).twice
        interface.store(as_list, name, as: :csv)
        interface.store_csv(as_list, name)
      end

      it 'can write the raw string to s3' do
        expect(subject).to receive(:put).with(body: random_str).twice
        interface.store(random_str, name, as: :identity)
        interface.store_string(random_str, name)
      end

      it 'uses a UUID if the key is not explicitly passed' do
        s3_objects_to_pin('some_uuid')
        expect(subject).not_to receive(:put)
        expect(SecureRandom).to receive(:uuid).and_return('some_uuid')
        expect(s3_objects_to_pin['some_uuid']).to receive(:put).with(body: as_json)
        interface.store(as_hash)
      end

      it 'defaults to the default_converter' do
        expect(subject).to receive(:put).with(body: random_str)
        allow(interface).to receive(:default_converter).and_return(:foo)
        expect(interface).to receive(:converter
                        ).with(:foo).and_return(S3MPI::Converters::Identity)
        interface.store(random_str, name)
      end

      context 'when encountering Aws::Errors' do
        before do
          allow(subject).to receive(:put).twice.and_raise(Aws::S3::Errors::RequestTimeout)
          allow(subject).to receive(:put).once.and_return('SUCCESS')
        end

        it 'retries' do
          expect(S3MPI::Converters::JSON).to receive(:generate).with(as_hash).and_call_original
          expect(interface.store(as_hash, name, tries: 3)).to eq 'SUCCESS'
        end
      end
    end
  end
end
