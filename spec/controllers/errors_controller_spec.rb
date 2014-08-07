require 'spec_helper'

describe ErrorsController do

  describe 'GET #not_found' do
    it 'renders the view' do
      get :not_found
      expect(response).to render_template :not_found
    end

    it 'has a status of 404' do
      get :not_found
      expect(response.status).to eq 404
    end
  end

  describe 'GET #unacceptable' do
    it 'renders the view' do
      get :unacceptable
      expect(response).to render_template :unacceptable
    end

    it 'has a status of 422' do
      get :unacceptable
      expect(response.status).to eq 422
    end
  end

  describe 'GET #internal_error' do
    it 'renders the view' do
      get :internal_error
      expect(response).to render_template :internal_error
    end

    it 'has a status of 500' do
      get :internal_error
      expect(response.status).to eq 500
    end
  end
end
