RSpec.shared_examples 'a parsed CSV' do
  it 'converts CSV data to an array of hashes' do
    expect(subject).to be_kind_of Array

    subject.each do |row|
      expect(row).to be_kind_of Hash
    end
  end

  it 'preserves integers' do
    subject.each do |row|
      expect(row['integer']).to eq(row['integer'].to_s.to_i)
    end
  end

  it 'preserves floats' do
    subject.each do |row|
      expect(row['float']).to eq(row['float'].to_s.to_f)
    end
  end
end
