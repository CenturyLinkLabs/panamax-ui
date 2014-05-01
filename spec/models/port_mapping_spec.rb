require 'spec_helper'

describe PortMapping do
  let(:attributes) do
    {
      'host_port' => 8080,
      'container_port' => 80
    }
  end

  subject { described_class.new(attributes) }

  describe '#host_port' do
    it 'exposes the host port' do
      expect(subject.host_port).to eq 8080
    end
  end

  describe '#container_port' do
    it 'exposes a the container port' do
      expect(subject.container_port).to eq 80
    end
  end

  describe '.new_from_collection' do
    it 'instantiates itself with each item in the collection' do
      collection = [
        { 'host_port' => 1, 'container_port' => 2 },
        { 'host_port' => 77, 'container_port' => 99 },
      ]

      result = described_class.new_from_collection(collection)

      expect(result.map(&:host_port)).to eq [1, 77]
      expect(result.map(&:container_port)).to eq [2, 99]
    end
  end
end
