require 'spec_helper'

describe TemplatesController do

  let(:fake_user) { double(:fake_user) }
  let(:fake_template_form) { double(:fake_template_form, save: true) }
  let(:fake_types) { double(:fake_types) }

  before do
    User.stub(:find).and_return(fake_user)
    TemplateForm.stub(:new).and_return(fake_template_form)
    Type.stub(:all).and_return(fake_types)
  end

  describe 'GET #new' do
    it 'hydrates the template form with a user, types, and app_id' do
      expect(TemplateForm).to receive(:new).with(
        types: fake_types,
        user: fake_user,
        app_id: '7'
      )
      get :new, app_id: 7
    end

    it 'renders the new view' do
      get :new
      expect(response).to render_template :new
    end

    it 'looks up and assign the user' do
      get :new
      expect(assigns(:user)).to eq fake_user
    end

    it 'assigns a template form' do
      get :new
      expect(assigns(:template_form)).to eq fake_template_form
    end
  end

  describe 'POST #create' do
    let(:create_params) do
      {
        'name' => 'My template'
      }
    end

    it 'looks up and assign the user' do
      post :create
      expect(assigns(:user)).to eq fake_user
    end

    it 'assigns a template form with the supplied parameters' do
      expect(TemplateForm).to receive(:new).with(create_params).and_return(fake_template_form)
      post :create, 'template_form' => create_params
      expect(assigns(:template_form)).to eq fake_template_form
    end

    context 'when saving is successful' do
      before do
        fake_template_form.stub(:save).and_return(true)
      end

      it 'sets a successful flash message' do
        post :create, 'template_form' => create_params
        expect(flash[:success]).to eq 'Template successfully created.'
      end

      it 'redirects to the applications path' do
        post :create, 'template_form' => create_params
        expect(response).to redirect_to apps_path
      end
    end

    context 'when saving is not successful' do
      before do
        fake_template_form.stub(:save).and_return(false)
        fake_template_form.stub(:errors).and_return(['some stuff'])
      end

      it 're-renders the templates#new view' do
        post :create, 'template_form' => create_params
        expect(response).to render_template :new
      end
    end
  end
end
