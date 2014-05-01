require 'spec_helper'

describe EnvironmentVariable do
  let(:attributes) do
    {
      'name' => 'DB_PASSWORD',
      'value' => 'pazzword'
    }
  end

  subject { described_class.new(attributes) }

  describe '#name' do
    it 'exposes the name' do
      expect(subject.name).to eq 'DB_PASSWORD'
    end
  end

  describe '#value' do
    it 'exposes the value' do
      expect(subject.value).to eq 'pazzword'
    end
  end

  describe '.new_from_hash' do
    it 'creates a new instance of itself for each key value pair' do
      hash = {
        'MY_VAR' => 'some value',
        'FOO' => 'bar'
      }
      result = described_class.new_from_hash(hash)

      expect(result.map(&:name)).to eq ['MY_VAR', 'FOO']
      expect(result.map(&:value)).to eq ['some value', 'bar']
    end
  end
end
