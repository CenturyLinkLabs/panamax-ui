require 'spec_helper'

describe MetricsController do
  let(:fake_metric_service) { double(:fake_metric_service) }
  let(:fake_response) do
    {
      'spec' => { 'cpu' => { 'limit' => 1, 'usage' => 10 }, 'memory' => { 'limit' => 100, 'usage' => 10 } },
      'stats' => [{ 'memory' => { 'usage' => 0 }, 'cpu' => { 'usage' => 0 } }]
    }
  end

  before do
    fake_metric_service.stub(:all).and_return(fake_response)
    CadvisorService.stub(:new).and_return(fake_metric_service)
  end

  describe 'GET #index' do
    it 'uses service to get all metrics' do
      expect(fake_metric_service).to receive(:all)
      get :index, format: :json
    end
  end

  describe 'GET #overall' do
    let(:overall) do
      {
        'cpu' => { 'usage' => 0 },
        'memory' => { 'usage' => 0 },
        'overall_cpu' => { 'usage' => 0, 'percent' => 0 },
        'overall_mem' => { 'usage' => 0.0, 'percent' => 0.0 }
      }
    end

    it 'uses service to get all metrics' do
      expect(fake_metric_service).to receive(:all)
      get :index, format: :json
    end

    it 'returns an overall metric element' do
      result = subject.overall_metric(fake_response)
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
      result = subject.overall_cpu([], cpu: { limit: 100 })
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
      result = subject.overall_memory([], memory: { limit: 100 })
      expect(result).to eq metric
    end
  end
end
