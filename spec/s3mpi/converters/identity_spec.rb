require 'spec_helper'

describe S3MPI::Converters::Identity do

  describe '#parse' do
    let(:data){ "any\nrandom\nstring" }

    it 'returns the input data' do
      expect(described_class.parse(data)).to equal data
    end
  end

end
