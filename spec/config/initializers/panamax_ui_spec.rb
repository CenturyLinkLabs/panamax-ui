require 'spec_helper'

describe PanamaxUi do
  describe '.allow_insecure_registries' do
    it 'returns NO if nothing is set' do
      ENV['INSECURE_REGISTRY'] = ''
      expect(described_class.allow_insecure_registries).to eq 'NO'
    end

    it 'returns NO if set to N' do
      ENV['INSECURE_REGISTRY'] = 'N'
      expect(described_class.allow_insecure_registries).to eq 'NO'
    end

    it 'returns YES if set to Y' do
      ENV['INSECURE_REGISTRY'] = 'Y'
      expect(described_class.allow_insecure_registries).to eq 'YES'
    end
  end
end
