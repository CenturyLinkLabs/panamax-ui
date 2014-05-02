require 'spec_helper'

describe Link do
  let(:attributes) do
    {
      'service_name' => 'DB'
    }
  end

  it_behaves_like 'a view model'

  subject { described_class.new(attributes) }

  describe '#service_name' do
    it 'exposes the service_name' do
      expect(subject.service_name).to eq 'DB'
    end
  end

  describe '.instantiate_collection' do
    let(:collection) do
      [
        { 'service_name' => 'foo'},
        { 'service_name' => 'bar'}
      ]
    end

    it 'instantiates itself with each item in the collection' do
      result = described_class.instantiate_collection(collection)
      expected = [
        described_class.new(collection[0]),
        described_class.new(collection[1])
      ]

      expect(result).to eq expected
    end
  end
end
