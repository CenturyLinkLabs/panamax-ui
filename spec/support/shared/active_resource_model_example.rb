shared_examples 'an active resource model' do

  describe '#write_attributes' do
    let(:attributes) do
      {
        foo: 'bar'
      }
    end

    it 'calls the public setter for each attribute' do
      expect(subject).to receive(:foo=).with('bar')
      subject.write_attributes(attributes)
    end
  end

  describe '.find_by_id' do
    it 'finds the record by the given id' do
      described_class.stub(:find).and_return 'thing'
      expect(described_class.find_by_id(1)).to eq 'thing'
    end

    it 'returns nil if the record does not exist' do
      described_class.stub(:find).and_raise(ActiveResource::ResourceNotFound.new(double('err', code: '404')))
      expect(described_class.find_by_id(99)).to be_nil
    end
  end

end
