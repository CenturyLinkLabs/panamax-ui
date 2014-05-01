require 'spec_helper'

describe Service do
  let(:response_attributes) do
    {
      'name' => 'Wordpress',
      'id' => 77,
      'categories' => [{'name' => 'foo'}, {'name' => 'baz'}]
    }
  end

  let(:fake_json_response) { response_attributes.to_json }

  describe '.create_from_response' do
    it 'instantiates itself with the parsed json attributes' do
      result = described_class.create_from_response(fake_json_response)
      expect(result).to be_a Service
      expect(result.name).to eq 'Wordpress'
      expect(result.id).to eq 77
    end

    it 'instantiates a ServiceCategory for each nested category' do
      result = described_class.create_from_response(fake_json_response)
      expect(result.categories.map(&:name)).to match_array(['foo', 'baz'])
      expect(result.categories.map(&:class).uniq).to match_array([ServiceCategory])
    end
  end

  describe '#to_param' do
    subject { described_class.new('id' => 77) }

    it 'returns the id' do
      expect(subject.to_param).to eq 77
    end
  end

  describe '#as_json' do
    subject { Service.new(response_attributes) }

    it 'provides the attributes to be converted to JSON' do
      expected = response_attributes
      expect(subject.as_json).to eq expected
    end
  end

end
