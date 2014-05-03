require 'spec_helper'

describe PortMapping do
  let(:attributes) do
    {
      'host_port' => 8080,
      'container_port' => 80
    }
  end

  it_behaves_like 'a view model'

  it_behaves_like 'a collection builder', [
    { 'host_port' => 8080, 'container_port' => 80 },
    { 'host_port' => 7070, 'container_port' => 82 }
  ]

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
end
