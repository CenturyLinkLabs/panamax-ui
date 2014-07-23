require 'spec_helper'

describe ApplicationController do

  describe 'handling StandardError exceptions' do

    controller do
      def index
        raise StandardError, 'oops'
      end
    end

    it 'logs some info at the error level' do
      expect(controller.logger).to receive(:error).once
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

      it 'renders the error message in the response body' do
        get :index
        expect(response.body).to eql({ message: 'oops' }.to_json)
      end
    end

    context 'when request is not XHR' do

      it 'redirects to the index' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'flashes an alert' do
        get :index
        expect(flash[:alert]).to eq 'oops'
      end
    end
  end

  describe 'handling EOFError exceptions' do

    controller do
      def index
        raise EOFError, 'oops'
      end
    end

    context 'when request is XHR' do

      before do
        controller.request.stub(xhr?: true)
      end

      it 'returns panamax API connection message in the response body' do
        get :index
        expect(response.status).to eq 500
        expect(response.body).to eql(
          { message: I18n.t(:panamax_api_connection_error) }.to_json)
      end
    end

    context 'when request is not XHR' do

      it 'flashes the panamax API connection message' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq I18n.t(:panamax_api_connection_error)
      end
    end
  end

  describe '#handle_exception' do

    context 'when the request is XHR' do

      before do
        controller.request.stub(xhr?: true)
      end

      context 'when a message is provided' do

        controller do
          def index
            raise StandardError, 'oops'
          rescue => ex
            handle_exception(ex, message: 'uh-oh')
          end
        end

        it 'renders the provided message in the response body' do
          get :index

          expect(response.status).to eq 500
          expect(response.body).to eql({ message: 'uh-oh' }.to_json)
        end
      end

      context 'when a translated message key is provided' do

        controller do
          def index
            raise StandardError, 'oops'
          rescue => ex
            handle_exception(ex, message: :hello)
          end
        end

        it 'renders the translated message in the response body' do
          get :index

          expect(response.status).to eq 500
          expect(response.body).to eql(
            { message: I18n.t(:hello) }.to_json)
        end
      end
    end

    context 'when the request is not XHR' do

      context 'when a message is provided' do

        controller do
          def index
            raise StandardError, 'oops'
          rescue => ex
            handle_exception(ex, message: 'uh-oh')
          end
        end

        it 'flashes the provided message' do
          get :index
          expect(flash[:alert]).to eq 'uh-oh'
        end
      end

      context 'when a translated message key is provided' do

        controller do
          def index
            raise StandardError, 'oops'
          rescue => ex
            handle_exception(ex, message: :hello)
          end
        end

        it 'flashes the translated message' do
          get :index
          expect(flash[:alert]).to eq I18n.t(:hello)
        end
      end

      context 'when a redirect path is provided' do

        controller do
          def index
            raise StandardError, 'oops'
          rescue => ex
            handle_exception(ex, redirect: '/foo')
          end
        end

        it 'redirects to the specified path' do
          get :index
          expect(flash[:alert]).to eq 'oops'
          expect(response).to redirect_to '/foo'
        end
      end
    end

  end
end
