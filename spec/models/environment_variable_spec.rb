require 'spec_helper'

describe EnvironmentVariable do

  it_behaves_like 'a view model', {
    'name' => 'DB_PASSWORD',
    'value' => 'pazzword'
  }

  describe '.instantiate_collection' do
    it 'creates a new instance of itself for each key value pair' do
      hash = {
        'MY_VAR' => 'some value',
        'FOO' => 'bar'
      }

      result = described_class.instantiate_collection(hash)

      expected = [
        described_class.new(name: 'MY_VAR', value: 'some value'),
        described_class.new(name: 'FOO', value: 'bar')
      ]

      expect(result).to match_array expected
    end
  end
end
