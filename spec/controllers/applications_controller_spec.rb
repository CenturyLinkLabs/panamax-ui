require 'spec_helper'

describe ApplicationsController do
  let(:fake_applications_service) { double(:fake_applications_service) }
  let(:valid_app) { double(:valid_app, valid?: true, to_param: 77, documentation_to_html: 'adsf') }
  let(:fake_delete_response) { double(:fake_delete_response, body: 'test', status: 200)}

  before do
    controller.stub(:show_url)
    fake_applications_service.stub(:create).and_return(valid_app)
    fake_applications_service.stub(:destroy).and_return(fake_delete_response)
    ApplicationsService.stub(:new).and_return(fake_applications_service)
  end

  describe 'POST #create' do
    context 'if a tag is selected' do
      it 'creates an application via the service' do
        expect(fake_applications_service).to receive(:create).with({ 'image' => 'some/image', 'tag' => ':latest' })

        post :create, { application: { image: 'some/image', tag: ':latest' } }
      end
    end

    context 'if no tag is selected' do
      it 'creates an application via the service' do
        expect(fake_applications_service).to receive(:create).with({ 'image' => 'some/image', 'tag' => '' })

        post :create, { application: { image: 'some/image', tag: '' } }
      end
    end

    it 'assigns app' do
      post :create, { application: { image: 'some/image', tag: '' } }
      expect(assigns(:app)).to eq valid_app
    end

    context 'when the created app is valid' do
      before do
        fake_applications_service.stub(:create).and_return(valid_app)
      end

      it 'redirects to the show page' do
        post :create, {application: {image: 'some/image', tag: ''}}

        expect(response).to redirect_to application_url(77)
      end
    end

    context 'when app is not valid' do
      let(:invalid_app) { double(:invalid_app, valid?: false, to_param: 13) }

      before do
        fake_applications_service.stub(:create).and_return(invalid_app)
      end

      it 'renders the show template' do
        post :create, { application: { image: 'some/image', tag: '' } }
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#destroy' do
    it 'uses the applications service to destroy the application' do
      expect(fake_applications_service).to receive(:destroy).with('77')
      delete :destroy, { id: 77}
    end

    it 'redirects to applications index view when format is html' do
      delete :destroy, { id: 77 }
      expect(response).to redirect_to applications_path
    end

    it 'renders json response when format is json' do
      delete :destroy, { id: 77, format: :json}
      expect(response.status).to eq 200
      expect(response.body).to eql fake_delete_response.to_json
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

  describe 'GET #documentation' do
    render_views

    it 'renders the apps documentation with the documentation layout' do
      fake_applications_service.stub(:find_by_id).and_return(valid_app)
      get :documentation, id: 77
      expect(response.body).to_not match /<header>/m
      expect(response.body).to match /post-run-html/m
    end

    it 'returns 404 if there is no documentation for the app' do
      fake_applications_service.stub(:find_by_id).and_return(nil)
      get :documentation, id: 77
      expect(response.status).to eq 404
    end
  end

  describe 'GET #relations' do
    it 'renders the partial for the relationship view for the app' do
      fake_applications_service.stub(:find_by_id).and_return(valid_app)
      get :relations, id: 77
      expect(response.body).to_not match /<body>/m
    end
  end

  describe '#journal' do

    let(:journal_lines) do
      [
        { id: 1, message: 'foo' }
      ]
    end

    before do
      fake_applications_service.stub(:journal).and_return(journal_lines)
    end

    it 'uses the service to retrieve the journal' do
      expect(fake_applications_service).to receive(:journal)
        .with('1', 'cursor' => 'c1')
      get :journal, id: 1, cursor: 'c1', format: :json
    end

    it 'returns the journal lines' do
      get :journal, id: 1, cursor: 'c1', format: :json
      expect(response.body).to eq journal_lines.to_json
    end

    it 'returns a 200 status code' do
      get :journal, id: 1, cursor: 'c1', format: :json
      expect(response.status).to eq 200
    end
  end
end
