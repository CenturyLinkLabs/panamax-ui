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
end
