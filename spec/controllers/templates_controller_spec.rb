require 'spec_helper'

describe TemplatesController do

  let(:fake_user) { double(:fake_user) }
  let(:fake_template_form) { double(:fake_template_form) }

  before do
    User.stub(:find).and_return(fake_user)
    TemplateForm.stub(:new).and_return(fake_template_form)
  end

  describe 'GET #new' do
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
end
