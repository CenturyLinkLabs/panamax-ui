require 'spec_helper'

describe ServiceCategory do
  let(:attributes) do
    {
      'name' => 'App Tier',
      'id' => 77
    }
  end

  it_behaves_like 'a view model'
  it_behaves_like 'a collection builder', [
    {'name' => 'App tier'},
    {'name' => 'DB tier'}
  ]

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
end
