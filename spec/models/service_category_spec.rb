require 'spec_helper'

describe ServiceCategory do
  let(:attributes) do
    {
      'name' => 'App Tier',
      'id' => 77
    }
  end

  it_behaves_like 'a view model'

  subject { described_class.new(attributes) }

  describe '#name' do
    it 'exposes the name' do
      expect(subject.name).to eq 'App Tier'
    end
  end

  describe '#id' do
    it 'exposes the id' do
      expect(subject.id).to eq 77
    end
  end

  describe '.instantiate_collection' do
    it 'creates a new instance of itself for each item in the collection' do
      collection = [
        {'name' => 'App tier'},
        {'name' => 'DB tier'}
      ]
      result = described_class.instantiate_collection(collection)

      expect(result.map(&:name)).to eq ['App tier', 'DB tier']
    end
  end
end
