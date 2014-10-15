require 'spec_helper'

describe RegistriesController do

  describe 'GET #index' do

    let(:fake_registries) do
      [
        double(:fake_registry),
        double(:fake_registry)
      ]
    end

    before do
      Registry.stub(:all).and_return(fake_registries)
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns registries' do
      get :index
      expect(assigns(:registries)).to eq fake_registries
    end
  end

  describe 'POST #create' do
    let(:fake_registry) { [Registry.new(name: 'test', endpoint_url: 'localhost:5000')] }
    let(:registry_form_params) do
      { 'registry' =>
          { 'name' => 'foo',
            'endpoint_url' => 'localhost:1234'
          }
      }
    end

    context 'when create is successful' do

      before do
        Registry.any_instance.stub(:save)
      end

      it 'creates the registry' do
        expect(Registry).to receive(:new)
                           .with(
                             'name' => 'foo',
                             'endpoint_url' => 'localhost:1234'
                           )
                           .and_return(fake_registry)
        expect(fake_registry).to receive(:save)
        post :create, registry_form_params
      end
    end

    context 'when create is not successful' do

      before do
        Registry.any_instance.stub(:save).and_raise(StandardError.new)
      end

      it 'rescues an exception' do
        post :create, registry_form_params
        expect(response.body).to redirect_to(registries_url)
        expect(flash[:error]).to eq 'Your registry could not be added'
      end
    end
  end

  describe 'DELETE #destroy' do

    let(:fake_registry) { double(:fake_registry, destroy: true) }

    context 'when destroy is successful' do

      before do
        Registry.stub(:find).with('7').and_return(fake_registry)
      end

      it 'destroys the registry' do
        expect(fake_registry).to receive(:destroy)
        delete :destroy, id: '7'
        expect(flash[:success]).to eq I18n.t('registries.destroy.success')
      end
    end

    context 'when destroy is not successful' do

      before do
        Registry.stub(:find).with('7').and_raise(StandardError.new)
      end

      it 'rescues an exception' do
        delete :destroy, id: '7'
        expect(response.body).to redirect_to(registries_url)
        expect(flash[:error]).to eq I18n.t('registries.destroy.error')
      end
    end
  end

  describe 'PUT #update' do

    let(:registry_params) { { 'name' => 'updated name' } }
    let(:fake_registry) { double(:fake_registry, update_attributes: true) }

    before do
      Registry.stub(:find).with('3').and_return(fake_registry)
    end

    it 'updates the given record' do
      expect(fake_registry).to receive(:update_attributes).with(registry_params)
      put :update, id: 3, registry: registry_params
    end

    context 'when update is successfull' do
      it 'responds with a successful status code' do
        put :update, id: 3, registry: registry_params, format: :json
        expect(response.status).to eq 204
      end
    end

    context 'when the regsitry cannot be found' do
      before do
        Registry.stub(:find).and_raise(ActiveResource::ResourceNotFound.new(double('err', code: '404')))
      end

      it 'responds with a 302 status code' do
        put :update, id: 13, registry: registry_params, format: :json
        expect(response.status).to eq 302
      end
    end

    context 'as json' do
      it 'responds with the representation of the registry' do
        put :update, id: 3, registry: registry_params, format: :json
        expect(response.body).to eq ''
      end
    end
  end
end
