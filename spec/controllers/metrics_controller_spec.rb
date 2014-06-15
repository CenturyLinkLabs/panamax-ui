require 'spec_helper'

describe MetricsController do
  let(:fake_metric_service) { double(:fake_metric_service) }
  let(:fake_response) { double(:fake_response, body: '[{}]', status: 200)}

  before do
    fake_metric_service.stub(:all).and_return(fake_response)
    fake_metric_service.stub(:overall).and_return(fake_response)
    MetricService.stub(:new).and_return(fake_metric_service)
  end

  describe 'GET #index' do
    it 'uses service to get all metrics' do
      expect(fake_metric_service).to receive(:all)
      get :index, format: :json
    end
  end

  describe 'GET #overall' do
    it 'uses service to get overall metrics' do
      expect(fake_metric_service).to receive(:overall)
      get :overall, format: :json
    end
  end
end
