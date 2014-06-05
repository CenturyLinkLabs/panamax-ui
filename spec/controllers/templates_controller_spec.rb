require 'spec_helper'

describe TemplatesController do

  let(:user) { double(:user) }

  before do
    User.stub(:find).and_return(user)
  end

  describe 'GET #new' do
    it 'renders the new view' do
      get :new
      expect(response).to render_template :new
    end

    it 'looks up and assign the user' do
      get :new
      expect(assigns(:user)).to eq user
    end
  end
end
