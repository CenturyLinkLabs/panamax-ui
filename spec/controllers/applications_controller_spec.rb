require 'spec_helper'

describe ApplicationsController do
  let(:fake_applications_service) { double(:fake_applications_service) }
  let(:valid_app) { double(:valid_app, valid?: true, to_param: 77) }

  before do
    controller.stub(:show_url)
    fake_applications_service.stub(:create).and_return(valid_app)
    ApplicationsService.stub(:new).and_return(fake_applications_service)
  end

  describe 'POST #create' do
    it 'creates an application via the service' do
      expect(fake_applications_service).to receive(:create).with({'image'=>'some/image'})

      post :create, {application: {image: 'some/image'}}
    end

    it 'assigns app' do
      post :create, {application: {image: 'some/image'}}
      expect(assigns(:app)).to eq valid_app
    end

    context 'when the created app is valid' do
      before do
        fake_applications_service.stub(:create).and_return(valid_app)
      end

      it 'redirects to the show page' do
        post :create, {application: {image: 'some/image'}}

        expect(response).to redirect_to application_url(77)
      end
    end

    context 'when app is not valid' do
      let(:invalid_app) { double(:invalid_app, valid?: false, to_param: 13) }

      before do
        fake_applications_service.stub(:create).and_return(invalid_app)
      end

      it 'renders the show template' do
        post :create, {application: {image: 'some/image'}}
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #show' do
    it 'uses the service to retrieve the application' do
      expect(fake_applications_service).to receive(:find_by_id).with('77')
      get :show, id: 77
    end

    it 'assigns app' do
      fake_applications_service.stub(:find_by_id).and_return(valid_app)
      get :show, id: 77
      expect(assigns(:app)).to eq valid_app
    end

    it 'returns a 404 if the app is not found' do
      fake_applications_service.stub(:find_by_id).and_return(nil)
      get :show, id: 77
      expect(response.status).to eq 404
    end
  end
end
