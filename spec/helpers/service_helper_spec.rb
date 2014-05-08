require 'spec_helper'

describe ServiceHelper do
  describe '#service_details_class' do
    it 'returns nil if not disabled' do
      expect(service_details_class(false)).to be_nil
    end

    it 'returns loading if disabled' do
      expect(service_details_class(true)).to eq 'loading'
    end
  end
end
