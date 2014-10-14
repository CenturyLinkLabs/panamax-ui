require 'spec_helper'

describe ServiceHealthController do
  let(:fake_response) { double(:fake_response, overall: {}) }

  before do
    ServiceHealth.stub(:find).and_return(fake_response)
  end

  describe 'GET #show' do
    it 'uses ServiceHealth model' do
      expect(ServiceHealth).to receive(:find)
      get :show, id: 'TEST', format: :json
    end
  end
end
