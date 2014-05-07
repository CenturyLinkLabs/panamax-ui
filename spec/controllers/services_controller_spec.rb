require 'spec_helper'

describe ServicesController do
  let(:fake_applications_service) { double(:fake_applications_service) }
  let(:fake_services_service) { double(:fake_services_service) }
  let(:valid_app) { double(:valid_app) }
  let(:valid_service) { double(:valid_service, id: 3) }
  let(:fake_delete_response) { double(:fake_delete_response, body: 'test', status: 200)}

  before do
    ApplicationsService.stub(:new).and_return(fake_applications_service)
    ServicesService.stub(:new).and_return(fake_services_service)
    fake_applications_service.stub(:find_by_id).and_return(valid_app)
    Service.stub(:find).and_return(valid_service)
    fake_services_service.stub(:destroy).and_return(fake_delete_response)
  end

  describe 'GET #show' do
    it 'uses the application service to retrieve the application' do
      expect(fake_applications_service).to receive(:find_by_id).with('77')
      get :show, { application_id: 77, id: 89 }
    end

    it 'retrieves the service' do
      expect(Service).to receive(:find).with('3', {params: {app_id: '2'}})

      get :show, { application_id: 2, id: 3 }
    end

    it 'assigns app' do
      get :show, { application_id: 77, id: 89 }
      expect(assigns(:app)).to eq valid_app
    end

    it 'assigns service' do
      get :show, { application_id: 77, id: 89 }
      expect(assigns(:service)).to eq valid_service
    end
  end

  describe 'PATCH #update' do
    let(:attributes) {
      {
        'name' => 'DB_1',
        'links_attributes' => {
          '0' => {
            'service_id' => '4',
            'alias' => 'database'
          }
        }
      }
    }

    before do
      valid_service.stub(:write_attributes)
      valid_service.stub(:save)
    end

    it 'retrieves the service to be updated' do
      expect(Service).to receive(:find).with('3', {params: {app_id: '2'}})

      patch :update, { application_id: 2, id: 3 }
    end

    it 'writes the attributes' do
      expect(valid_service).to receive(:write_attributes).with(attributes)
      patch :update, { application_id: 2, id: 3, service: attributes }
    end

    it 'saves the record' do
      expect(valid_service).to receive(:save)
      patch :update, { application_id: 2, id: 3, service: attributes }
    end

    it 'redirects to the show page' do
      patch :update, { application_id: 2, id: 3, service: attributes }
      expect(response).to redirect_to application_service_path(2, 3)
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
