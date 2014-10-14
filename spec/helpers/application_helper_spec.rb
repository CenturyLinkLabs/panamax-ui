require 'spec_helper'

describe ApplicationHelper do
  before do
    HostHealth.stub(:site).and_return('/health/')
  end

  describe '#metrics_url' do

    it 'returns HostHealth.site value' do
      expect(metrics_url).to eq '/health/'
    end
  end

  describe '#metrics_url_for' do
    it 'returns HostHealth.site with service path appended' do
      expect(metrics_url_for('ME')).to eq '/health/containers/docker/ME'
    end
  end
end
