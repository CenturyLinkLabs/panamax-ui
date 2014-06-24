require 'spec_helper'

describe DockerStatus do

  describe '#initialize' do

    let(:attrs) { { foo: 'bar', fizz: 'bin' } }

    it 'merges the hash argument into itself' do
      obj = described_class.new(attrs)
      expect(obj).to eq attrs
    end
  end
end
