require 'spec_helper'

describe Link do
  let(:attributes) do
    {
      'service_name' => 'DB'
    }
  end

  it_behaves_like 'a view model'
  it_behaves_like 'a collection builder', [
    { 'service_name' => 'foo'},
    { 'service_name' => 'bar'}
  ]

  subject { described_class.new(attributes) }

  describe '#service_name' do
    it 'exposes the service_name' do
      expect(subject.service_name).to eq attributes['service_name']
    end
  end
end
