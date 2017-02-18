require 'spec_helper'

describe S3MPI::Converters::JSON do

  describe '#parse' do
    it 'loads a JSON hash' do
      expect(described_class.parse('{ "a": 1, "b": "test" }')
                           ).to eql({ "a" => 1, "b" => "test"})
    end

    it 'loads a JSON array' do
      expect(described_class.parse('["a", 1, "b", 2]')
                           ).to eql(["a", 1, "b", 2])
    end

    it 'loads a JSON array of hashes' do
      expect(described_class.parse('[{ "a": "one" }, {"b": "two" }]')
                           ).to eql([{ "a" => "one" }, {"b" => "two"}])
    end

    it 'loads a single JSON element' do
      expect(described_class.parse('"hello world"')
                           ).to eql("hello world")
    end

    it 'loads the JSON null as nil' do
      expect(described_class.parse('null')).to be_nil
    end
  end

  describe '#generate' do
    it 'dumps a Hash' do
      expect(described_class.generate({ "a" => 1, "b" => "test"})
                           ).to eql('{"a":1,"b":"test"}')
    end

    it 'dumps an Array' do
      expect(described_class.generate(["a", 1, "b", 2])
                           ).to eql('["a",1,"b",2]')
    end

    it 'dumps an Array of Hashes' do
      expect(described_class.generate([{ "a" => "one" }, {"b" => "two"}])
                           ).to eql('[{"a":"one"},{"b":"two"}]')
    end

    it 'dumps a String' do
      expect(described_class.generate("hello world")
                           ).to eql('"hello world"')
    end

    it 'dumps the nil as the JSON null' do
      expect(described_class.generate(nil)).to eql 'null'
    end
  end

end
