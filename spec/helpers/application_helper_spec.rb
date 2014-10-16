require 'spec_helper'

describe ApplicationHelper do
  before do
    helper.request.host = 'localhost'
  end

  describe '#metrics_url' do

    it 'returns host health value' do
      expect(helper.metrics_url).to eq 'http://localhost:3002/'
    end
  end

  describe '#metrics_url_for' do
    it 'returns  service path appended' do
      expect(helper.metrics_url_for('ME')).to eq 'http://localhost:3002/containers/docker/ME'
    end
  end
end
