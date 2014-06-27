require 'spec_helper'

module S3MPI

  describe Format do
    let(:format_mixin) {
      klass = Class.new
      klass.send :include, Format
      klass.new
    }

    it 'expects #parse_json_allowing_quirks_mode to parse JSON' do
      obj = {"a" => 1, "b" => "test"}
      expect(format_mixin.parse_json_allowing_quirks_mode(obj.to_json)).to eql(obj)
    end

  end

end
