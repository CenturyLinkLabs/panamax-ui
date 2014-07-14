require 'spec_helper'

describe ApplicationController do

  controller do
    def index
      raise EOFError
    end
  end

  describe 'handling EOFError' do

    it 'logs some info at the error level' do
      expect(controller.logger).to receive(:error).twice
      get :index
    end

    context 'when request is XHR' do

      before do
        controller.request.stub(xhr?: true)
      end

      it 'returns a 500 status code' do
        get :index
        expect(response.status).to eq 500
      end
    end

    context 'when request is not XHR' do

      it 'redirects to the index' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'flashes an alert' do
        get :index
        expect(flash[:alert]).to eq 'Panamax API is not responding'
      end
    end
  end
end
