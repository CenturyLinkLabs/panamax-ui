require 'spec_helper'

describe TemplatesController do

  let(:fake_user) { double(:fake_user) }
  let(:fake_template_form) { double(:fake_template_form, repo: 'foo/bar', save: true) }
  let(:fake_app) { double(:fake_app, id: 7) }
  let(:fake_types) { double(:fake_types) }
  let(:fake_template) { double(:fake_template, id: 1) }

  before do
    Template.stub(:find).and_return(fake_template)
    User.stub(:find).and_return(fake_user)
    TemplateForm.stub(:new).and_return(fake_template_form)
    App.stub(:find).and_return(fake_app)
    Type.stub(:all).and_return(fake_types)
  end

  describe 'GET #new' do
    it 'hydrates the template form with a user, types, and app_id' do
      expect(TemplateForm).to receive(:new).with(
        types: fake_types,
        user: fake_user,
        app: fake_app
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

  context 'when an app cannot be found' do
    before do
      App.stub(:find).and_raise(ActiveResource::ResourceNotFound.new(double('err', code: '404')))
    end

    it 'redirects to the apps page with a flash message' do
      get :new
      expect(flash[:alert]).to eq 'could not find application'
      expect(response).to redirect_to(apps_path)
    end
  end

  describe 'POST #create' do

    let(:create_params) do
      {
        'name' => 'My template',
        'repo' => 'foo/bar'
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

      it 'adds the repo to the template_repo sources' do
        expect(TemplateRepo).to receive(:find_or_create_by_name).with(create_params['repo'])
        post :create, 'template_form' => create_params
      end

    end

    context 'when saving is not successful' do
      before do
        fake_template_form.stub(:save).and_return(false)
        fake_template_form.stub(:errors).and_return(['some stuff'])
        fake_template_form.stub(:user=).and_return(true)
        fake_template_form.stub(:types=).and_return(true)
      end

      it 're-renders the templates#new view' do
        post :create, 'template_form' => create_params
        expect(response).to render_template :new
      end

      it 'does not add the repo to the template_repo sources' do
        expect(TemplateRepo).to_not receive(:find_or_create_by_name)
        post :create, 'template_form' => create_params
      end

    end
  end

  context 'for template_repo' do
    it 'invokes create unless repo already exists' do
      expect(TemplateRepo).to_not receive(:create).with(name: 'user/publicrepo')
      post :create, name: 'user/publicrepo'
    end
  end

  describe 'GET #details' do
    it 'assigns the template' do
      get :details, id: 1
      expect(assigns(:template)).to eq fake_template
      expect(assigns(:template).id).to eq 1
    end
    it 'renders the details view' do
      get :details, id: 1
      expect(response).to render_template :details
    end
    it 'renders without a layout' do
      get :details, id: 1
      expect(response).to render_template(layout: nil)
    end
  end
end
