shared_examples 'a collection builder' do |hashes|

  describe '.instantiate_collection' do

    it 'returns a collection' do
      expect(described_class.instantiate_collection(hashes)).to be_kind_of Array
    end

    it "returns instances of #{described_class}" do
      result = described_class.instantiate_collection(hashes)

      expected = hashes.map { |hash| described_class.new(hash) }
      expect(result).to eq expected
    end

    context 'when argument is nil' do

      it 'returns an empty collection' do
        expect(described_class.instantiate_collection(nil)).to eq []
      end
    end
  end
end
