require 'spec_helper'

describe ServiceHelper do
  describe '#linkable_service_options' do
    let(:services) do
      [
        double(:service_1, id: 1, name: 'first'),
        double(:service_2, id: 2, name: 'second')
      ]
    end

    it 'returns a structure to be passed to a select' do
      result = linkable_service_options(services, 999)
      expected = [
        ['first', 1],
        ['second', 2]
      ]
      expect(result).to eq(expected)
    end

    it 'filters out the current service' do
      result = linkable_service_options(services, 2)
      expected = [
        ['first', 1]
      ]
      expect(result).to eq(expected)
    end

    it 'uses name as key when :name is third parameter' do
      result = linkable_service_options(services, 2, :name)
      expected = [
        ['first', 'first']
      ]
      expect(result).to eq(expected)
    end
  end
end
