require 'spec_helper'

describe AppsController do
  let(:dummy_app) do
    App.new
  end

  let(:fake_delete_response) { double(:fake_delete_response, body: 'test', status: 200) }

  before do
    allow(controller).to receive(:show_url)
    allow(App).to receive(:find).and_return(dummy_app)
    allow(dummy_app).to receive(:id).and_return(77)
    allow(dummy_app).to receive(:categories).and_return([
      Category.new(id: 33, name: 'Test3', position: 3),
      Category.new(id: 22, name: 'Test2', position: 2),
      Category.new(id: 11, name: 'Test1', position: 1)
    ])
  end

  describe 'POST #create' do
    before do
      allow(App).to receive(:create).and_return(dummy_app)
    end

    it 'creates an application' do
      expect(App).to receive(:create).with('image' => 'some/image', 'tag' => ':latest').and_return(dummy_app)

      post :create, app: { image: 'some/image', tag: ':latest' }
    end

    it 'assigns app' do
      post :create, app: { image: 'some/image', tag: ':latest' }
      expect(assigns(:app)).to eq dummy_app
    end

    context 'when the created app is valid' do
      before do
        allow(dummy_app).to receive(:valid?).and_return(true)
      end

      it 'redirects to the show page' do
        post :create, app: { image: 'some/image', tag: ':latest' }

        expect(response).to redirect_to app_url(77)
      end

      it 'shows a success message' do
        post :create, app: { image: 'some/image', tag: ':latest' }
        expect(flash[:success]).to eql I18n.t('apps.create.success')
      end
    end

    context 'when app is not valid' do
      before do
        allow(App).to receive(:create).and_return(false)
      end

      it 'renders the show template' do
        post :create, app: { image: 'some/image', tag: ':latest' }
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'PUT #update' do
    let(:attributes) do
      {
        'name' => 'My App',
        'id' => '77'
      }
    end

    before do
      allow(App).to receive(:find).and_return(dummy_app)
      allow(dummy_app).to receive(:save)
    end

    it 'retrieves the app to be updated' do
      expect(App).to receive(:find).with('77')
      patch :update, app: attributes, id: '77', format: :json
    end

    it 'writes the attributes' do
      expect(dummy_app).to receive(:write_attributes).with(attributes)
      patch :update, id: '77', app: attributes, format: :json
    end

    it 'saves the record' do
      expect(dummy_app).to receive(:save)
      patch :update, id: '77', app: attributes, format: :json
    end
  end

  describe '#destroy' do
    before do
      allow(dummy_app).to receive(:destroy)
    end

    it 'uses the applications service to destroy the application' do
      expect(dummy_app).to receive(:destroy)
      delete :destroy, id: 77, format: :html
    end

    it 'redirects to applications index view when format is html' do
      delete :destroy, id: 77, format: :html
      expect(response).to redirect_to apps_path
    end

    it 'renders json response when format is json' do
      delete :destroy, id: 77, format: :json
      expect(response.status).to eq 204
    end
  end

  describe 'GET #index' do
    let(:apps) { [App.new] }
    before do
      allow(App).to receive(:all).and_return(apps)
    end

    it 'retrieves all the applications' do
      get :index
      expect(assigns(:apps)).to eq apps
    end
  end

  describe 'GET #show' do
    it 'retrieves the application' do
      expect(App).to receive(:find).with('77')
      get :show, id: 77
    end

    it 'assigns app' do
      get :show, id: 77
      expect(assigns(:app)).to eq dummy_app
    end

    it 'sorts the categories by position' do
      get :show, id: 77
      expect(dummy_app.categories.first.position).to eq 1
    end

    it 'returns a 404 if the app is not found' do
      allow(App).to receive(:find).and_raise(ActiveResource::ResourceNotFound.new(double('err', code: '404')))
      get :show, id: 77
      expect(response.status).to eq 404
    end
  end

  describe 'GET #documentation' do
    it 'renders the apps documentation with the documentation layout' do
      allow(dummy_app).to receive(:documentation_to_html).and_return('<p>some instructions</a>')
      get :documentation, id: 77
      expect(response).to render_template('documentation', layout: 'plain')
    end

    it 'returns 404 if there is no documentation for the app' do
      get :documentation, id: 77
      expect(response.status).to eq 404
    end
  end

  describe 'GET #relations' do
    it 'renders the partial for the relationship view for the app' do
      get :relations, id: 77
      expect(response).to render_template(partial: '_relationship_view')
      expect(response.body).to_not match(/<body>/m)
    end
  end

  describe 'POST #template' do
    let(:template_response) do
      double(:template_response,
             body: '{ "template": "My Template String" }',
             status: 200
            )
    end

    before do
      allow(dummy_app).to receive(:post).and_return(template_response)
    end

    it 'retrieve the template' do
      expect(dummy_app).to receive(:post)
        .with(:template, nil)
      post :template, id: 1, format: :json
    end

    it 'returns the template string received' do
      post :template, id: 1, format: :json
      expect(response.body).to eq template_response.body
    end
  end

  describe '#journal' do
    let(:journal_lines) do
      [
        { id: 1, message: 'foo' }
      ]
    end

    before do
      allow(dummy_app).to receive(:get).and_return(journal_lines)
    end

    it 'retrieve the journal' do
      expect(dummy_app).to receive(:get)
        .with(:journal, 'cursor' => 'c1')
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

  describe '#compose_yml' do
    let(:compose) do
      '{"compose_yaml": "---\nWP:\n  image: centurylink/wordpress:3.9.1\n"}'
    end

    before do
      allow(Net::HTTP).to receive(:get).and_return(compose)
    end

    it 'retrieves the compose yaml representation of the app' do
      expect(Net::HTTP).to receive(:get).with(URI("#{PanamaxApi::URL}/apps/#{dummy_app.id}/compose_yml.json"))
      get :compose_yml, id: 1, format: :json
    end

    it 'returns the compose yaml' do
      get :compose_yml, id: 1, format: :json
      expect(response.body).to eq compose
    end

    it 'returns a 200 status code' do
      get :compose_yml, id: 1, format: :json
      expect(response.status).to eq 200
    end
  end

  describe '#rebuild' do
    it 'rebuilds the application' do
      expect(dummy_app).to receive(:put).with(:rebuild)
      put :rebuild, id: 77
    end

    context 'when successful' do
      before do
        allow(dummy_app).to receive(:put).and_return(true)
      end

      it 'redirects to the applications index view when format is html' do
        put :rebuild, id: 77
        expect(response).to redirect_to apps_path
      end

      it 'sets a flash success message' do
        put :rebuild, id: 77
        expect(flash[:success]).to eq I18n.t('apps.rebuild.success')
      end

      it 'returns no content for json' do
        put :rebuild, id: 77, format: :json
        expect(response.body).to eq ''
      end
    end

    context 'when unsuccessful' do
      before do
        allow(dummy_app).to receive(:put).and_return(false)
      end

      it 'returns status 302 when format is html' do
        put :rebuild, id: 77
        expect(response.status).to eq 302
      end

      it 'sets a flash alert' do
        put :rebuild, id: 77
        expect(flash[:alert]).to eq I18n.t('apps.rebuild.error')
      end

      it 'returns status 204 when format is json' do
        put :rebuild, id: 77, format: :json
        expect(response.status).to eq 204
      end
    end

    context 'when an ActiveResource::ServerError occurs' do
      before do
        allow(dummy_app).to receive(:put).and_raise(
          ActiveResource::ServerError.new(nil, 'oops'))
      end

      context 'when a referer is present' do
        before do
          request.env['HTTP_REFERER'] = '/some/path'
        end

        it 'flashes the error message' do
          put :rebuild, id: 77
          expect(flash[:alert]).to eq 'oops'
        end

        it 'redirects to the referer' do
          put :rebuild, id: 77
          expect(response).to redirect_to('/some/path')
        end
      end

      context 'when a referer is not present' do
        it 'flashes the error message' do
          put :rebuild, id: 77
          expect(flash[:alert]).to eq 'oops'
        end

        it 'redirects to the apps_path' do
          put :rebuild, id: 77
          expect(response).to redirect_to(apps_path)
        end
      end
    end
  end
end
