require 'spec_helper'

describe Link do
  let(:attributes) do
    {
      'service_name' => 'DB'
    }
  end

  subject { described_class.new(attributes) }

  describe '#service_name' do
    it 'exposes the service_name' do
      expect(subject.service_name).to eq 'DB'
    end
  end

  describe '.instantiate_collection' do
    it 'instantiates itself with each item in the collection' do
      collection = [
        { 'service_name' => 'foo'},
        { 'service_name' => 'bar'}
      ]

      result = described_class.instantiate_collection(collection)

      expect(result.map(&:service_name)).to match_array ['foo', 'bar']
    end
  end
end
