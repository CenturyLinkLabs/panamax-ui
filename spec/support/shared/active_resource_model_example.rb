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
      allow(described_class).to receive(:find).and_return 'thing'
      expect(described_class.find_by_id(1)).to eq 'thing'
    end

    it 'returns nil if the record does not exist' do
      allow(described_class).to(
        receive(:find).and_raise(ActiveResource::ResourceNotFound.new(double('err', code: '404')))
      )
      expect(described_class.find_by_id(99)).to be_nil
    end
  end

  describe '.all_with_response' do

    let(:response) { double('response', body: '{}', header: { 'Total-Count' => '1' }) }
    let(:connection) { double('connection', get: response) }
    let(:collection) { %w(foo baz bar) }

    before do
      allow(described_class).to receive(:prefix_parameters).and_return({}) # ignore model prefix
      allow(described_class).to receive(:connection).and_return(connection)
      allow(described_class).to receive(:instantiate_collection).and_return(collection)
    end

    it 'makes a GET request with the proper path' do
      expect(connection).to receive(:get).with("#{described_class.collection_path}", {}).and_return(response)
      described_class.all_with_response
    end

    it 'returns an object which is effectively the same as the collection passed' do
      wrapper = described_class.all_with_response
      expect(wrapper).to eq(collection)
    end

    it 'returns an object that responds to #response' do
      wrapper = described_class.all_with_response
      expect(wrapper.respond_to?(:response)).to be true
    end

    it 'returns an object that returns the response when sent :response' do
      wrapper = described_class.all_with_response
      expect(wrapper.response).to eq(response)
    end
  end
end
