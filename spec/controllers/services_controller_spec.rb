require 'spec_helper'

describe ServicesController do
  let(:valid_app) { double(:valid_app) }
  let(:valid_service) { double(:valid_service, id: 3) }
  let(:fake_create_response) { double(:fake_create_response, body: 'test', status: 200) }
  let(:app_services) { double([Service.new]) }

  before do
    allow(App).to receive(:find).and_return(valid_app)
    allow(Service).to receive(:find).and_return(valid_service)
    allow(valid_service).to receive(:categories=)
    allow(valid_service).to receive(:hydrate_linked_services!).and_return(Service.new)
    allow(valid_app).to receive(:services).and_return(app_services)
  end

  describe 'GET #show' do
    it 'uses the application service to retrieve the application' do
      expect(App).to receive(:find).with('77')
      get :show, app_id: 77, id: 89
    end

    it 'retrieves the service' do
      expect(Service).to receive(:find).with('3', params: { app_id: '2' })

      get :show, app_id: 2, id: 3
    end

    it 'assigns app' do
      get :show, app_id: 77, id: 89
      expect(assigns(:app)).to eq valid_app
    end

    it 'assigns service' do
      get :show, app_id: 77, id: 89
      expect(assigns(:service)).to eq valid_service
    end

    it 'hydrates the linked services' do
      expect(valid_service).to receive(:hydrate_linked_services!)
      get :show, app_id: 77, id: 89
    end

    context 'when format is JSON' do
      it 'returns the JSON-serialized service' do
        get :show, app_id: 77, id: 89, format: :json
        expect(response.body).to eq valid_service.to_json
      end
    end
  end

  describe 'category param builder' do

    context 'in Uncategorized or Services category' do
      let(:application_params) do
        { category: 'null' }
      end

      it 'does not assign a category' do
        expect(subject.build_category_param(application_params)).to eq nil
      end
    end

    context 'in a defined Category' do
      let(:application_params) do
        { category: 77 }
      end

      it 'puts category information into an array with an id hash' do
        expect(subject.build_category_param(application_params)).to eq [{ id: 77 }]
      end
    end
  end

  describe 'POST #create' do
    let(:dummy_category) { double(:category) }
    let(:dummy_service) { Service.new(name: 'test', from: 'test:latest') }
    let(:service_form_params) do
      {
        'app' =>
          {
            'category' => '1'
          },
        'name' => 'tutum/wordpress',
        'app_id' => '77',
      }
    end

    before do
      allow(Category).to receive(:find).and_return(dummy_category)
      allow_any_instance_of(Service).to receive(:save)
    end

    it 'creates the service' do
      expect(Service).to receive(:new)
        .with(
          name: 'tutum/wordpress',
          from: 'tutum/wordpress:latest',
          app_id: '77'
        )
        .and_return(dummy_service)
      expect(dummy_service).to receive(:save)
      post :create, service_form_params, app_id: '77'
    end

    context 'when the tag is supplied' do
      before do
        service_form_params['app']['tag'] = 'fizzle'
      end

      it 'creates the service with the supplied tag' do
        expect(Service).to receive(:new)
          .with(
            name: 'tutum/wordpress',
            from: 'tutum/wordpress:fizzle',
            app_id: '77'
          )
          .and_return(dummy_service)
        expect(dummy_service).to receive(:save)
        post :create, service_form_params, app_id: '77'
      end

    end

    it 'redirected to application management view when format is html' do
      post :create, service_form_params
      expect(response).to redirect_to app_path 77
    end

    it 'renders json response when format is json' do
      post :create,
        name: 'test',
        app_id: '77',
        app: { category: 'null' },
        format: :json
      expect(response.status).to eq 200
      expect(response.body).to eql dummy_service.to_json
    end
  end

  describe 'PATCH #update' do
    let(:attributes) do
      {
        'name' => 'DB_1',
        'links_attributes' => {
          '0' => {
            'service_id' => '4',
            'alias' => 'database'
          }
        }
      }
    end

    let(:category_attributes) do
      {
        'name' => 'DB_1',
        'links_attributes' => {
          '0' => {
            'service_id' => '4',
            'alias' => 'database'
          }
        },
        'categories' => [
          {
            'id' => '1',
            'position' => nil
          }
        ]
      }
    end

    before do
      allow(valid_service).to receive(:write_attributes)
      allow(valid_service).to receive(:save).and_return(true)
    end

    it 'retrieves the service to be updated' do
      expect(Service).to receive(:find).with('3', params: { app_id: '2' })
      patch :update, service: {}, app_id: 2, id: 3
    end

    it 'writes the attributes' do
      expect(valid_service).to receive(:write_attributes).with(attributes)
      patch :update, app_id: 2, id: 3, service: attributes
    end

    it 'updates the service categories when present' do
      attributes['category'] = '1'
      expect(valid_service).to receive(:write_attributes).with(category_attributes)
      patch :update, app_id: 2, id: 3, service: attributes
    end

    it 'saves the record' do
      expect(valid_service).to receive(:save)
      patch :update, app_id: 2, id: 3, service: attributes
    end

    it 'redirects to the show page' do
      patch :update, app_id: 2, id: 3, service: attributes
      expect(response).to redirect_to app_service_path(2, 3)
    end

    context 'when saving fails' do
      before do
        allow(valid_service).to receive(:save).and_return(false)
        allow(valid_service).to receive(:reload).and_return(true)
        allow(valid_service).to receive(:hydrate_linked_services!).and_return(true)
      end

      it 'reloads the service' do
        patch :update, app_id: 2, id: 3, service: attributes
        expect(valid_service).to have_received(:reload)
      end

      it 'rehydrates linked services' do
        patch :update, app_id: 2, id: 3, service: attributes
        expect(valid_service).to have_received(:hydrate_linked_services!)
      end

      it 're-renders the show page' do
        patch :update, app_id: 2, id: 3, service: attributes
        expect(response).to render_template :show
      end
    end
  end

  describe '#destroy' do
    before do
      allow(valid_service).to receive(:destroy)
    end

    it 'uses the services service to destroy the service' do
      expect(valid_service).to receive(:destroy)
      delete :destroy, app_id: 77, id: 89
    end

    it 'redirects to application management view when format is html' do
      delete :destroy, app_id: 77, id: 89
      expect(response).to redirect_to app_path 77
    end

    it 'renders json response when format is json' do
      delete :destroy, app_id: 77, id: 89, format: :json
      expect(response.status).to eq 204
    end
  end

  describe '#journal' do
    let(:journal_lines) do
      [
        { date: '1974-02-12', message: 'sparky' },
        { date: '1973-10-25', message: 'katie' }
      ]
    end

    before do
      allow(Service).to receive(:new).and_return(valid_service)
      allow(valid_service).to receive(:get).and_return(journal_lines)
    end

    context 'when the cursor param is nil' do

      it 'retrieves the journal from the API with a nil cursor' do
        expect(valid_service).to receive(:get).with(:journal, cursor: nil)
        get :journal, app_id: 77, id: 89, format: :json
      end
    end

    context 'when the cursor param is not nil' do

      let(:cursor) { 'cursor1' }

      it 'retrieves the journal from the API with a cursor' do
        expect(valid_service).to receive(:get).with(:journal, cursor: cursor)
        get :journal, app_id: 77, id: 89, cursor: cursor, format: :json
      end
    end

    it 'returns journal response in JSON format' do
      get :journal, app_id: 77, id: 89, format: :json
      expect(response.status).to eq 200
      expect(response.body).to eql journal_lines.to_json
    end
  end

  describe 'GET #index' do
    it 'uses the application service to retrieve the application' do
      expect(App).to receive(:find).with('77')
      get :index, app_id: 77, format: :json
    end

    context 'when format is JSON' do
      it 'returns the JSON-serialized services for the app' do
        get :index, app_id: 77, format: :json
        expect(response.body).to eq app_services.to_json
      end
    end
  end
end
