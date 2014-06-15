require 'spec_helper'

describe MetricService do
  let(:fake_connection) { double(:fake_connection) }
  let(:fake_request) { double(:fake_request) }
  let(:fake_response) { double(:fake_response, body: '[{}]', status: 200) }
  let(:fake_overall_response) { double(:fake_overall_response,
                                       body: '{"spec": {"cpu": {"limit": 1, "usage": 10}, "memory": {"limit": 100, "usage": 10}}, "stats": [{"memory": { "usage": 0 }, "cpu": { "usage": 0} }] }')}

  subject { MetricService.new(fake_connection) }

  describe '#all' do
    it 'issues a get request to the proper URL' do
      expect(fake_connection).to receive(:get).with('/api/v1.0/containers/').and_return(fake_response)
      subject.all
    end

    it 'returns a list of metrics' do
      fake_connection.stub(:get).and_return(fake_response)
      result = subject.all
      expect(result).to match_array [{}]
    end
  end

  describe '#overall' do
    let(:overall) do
      {
        "cpu" => { "usage" => 0 },
        "memory" => { "usage" => 0 },
        "overall_cpu" => { "usage" => 0, "percent" => 0 },
        "overall_mem" => { "usage" => 0.0, "percent" => 0.0 }
      }
    end

    it 'issues a get request to the proper URL' do
      expect(fake_connection).to receive(:get).with('/api/v1.0/containers/').and_return(fake_overall_response)
      subject.overall
    end

    it 'returns an overall metric element' do
      fake_connection.stub(:get).and_return(fake_overall_response)
      result = subject.overall
      expect(result).to eq overall
    end
  end

  describe '#overall_cpu' do
    let(:metric) do
      {
        'usage' => 0,
        'percent' => 0
      }
    end
    it 'returns a hash of cpu usage and percentage' do
      result = subject.overall_cpu([], { cpu: { limit: 100 }})
      expect(result).to eq metric
    end
  end

  describe '#overall_memory' do
    let(:metric) do
      {
          'usage' => 0,
          'percent' => 0
      }
    end
    it 'returns a hash of memory usage and percentage' do
      result = subject.overall_memory([], { memory: { limit: 100 }})
      expect(result).to eq metric
    end
  end
end
