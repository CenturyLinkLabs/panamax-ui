require 'spec_helper'

describe ServicesController do
  let(:fake_applications_service) { double(:fake_applications_service) }
  let(:fake_services_service) { double(:fake_services_service) }
  let(:valid_app) { double(:valid_app) }
  let(:valid_service) { double(:valid_service) }
  let(:fake_delete_response) { double(:fake_delete_response, body: 'test', status: 200)}

  before do
    ApplicationsService.stub(:new).and_return(fake_applications_service)
    ServicesService.stub(:new).and_return(fake_services_service)
    fake_applications_service.stub(:find_by_id).and_return(valid_app)
    fake_services_service.stub(:find_by_id).and_return(valid_service)
    fake_services_service.stub(:destroy).and_return(fake_delete_response)
  end

  describe 'GET #show' do
    it 'uses the application service to retrieve the application' do
      expect(fake_applications_service).to receive(:find_by_id).with('77')
      get :show, { application_id: 77, id: 89 }
    end

    it 'assigns app' do
      get :show, { application_id: 77, id: 89 }
      expect(assigns(:app)).to eq valid_app
    end

    it 'uses the services service to retrieve the service' do
      expect(fake_services_service).to receive(:find_by_id).with('77', '89')
      get :show, { application_id: 77, id: 89 }
    end

    it 'assigns service' do
      get :show, { application_id: 77, id: 89 }
      expect(assigns(:service)).to eq valid_service
    end
  end

  describe '#destroy' do
    it 'uses the services service to destroy the service' do
      expect(fake_services_service).to receive(:destroy).with('77','89')
      delete :destroy, { application_id: 77, id: 89 }
    end

    it 'redirects to application management view when format is html' do
      delete :destroy, { application_id: 77, id: 89 }
      expect(response).to redirect_to application_path 77
    end

    it 'renders json response when format is json' do
      delete :destroy, { application_id: 77, id: 89, format: :json}
      expect(response.status).to eq 200
      expect(response.body).to eql fake_delete_response.to_json
    end
  end
end
