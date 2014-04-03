require 'spec_helper'

describe SearchController do
  let(:fake_search_form) { double(:fake_search_form) }

  let(:fake_response_body) do
    {
      'remote_images' => [
        {
          'id' => 'ctlc/apache',
          'info' => { 'description' => 'some apache image' }
        }
      ]
    }
  end

  let(:fake_result_set) do
    double(:fake_result_set)
  end

  describe 'GET #new' do
    it 'creates and assigns a search object' do
      expect(SearchForm).to receive(:new).and_return(fake_search_form)

      get :new

      expect(assigns(:search_form)).to eq fake_search_form
    end
  end

  describe 'GET #show' do
    before do
      SearchForm.stub(:new).and_return(fake_search_form)
    end

    it 'searches for the supplied query' do
      expect(fake_search_form).to receive(:submit).with({'query' => 'apache'}).and_return(fake_result_set)

      get :show, {search_form: {query: 'apache'}}
    end

    context 'when successful' do
      context 'when an html request' do
        it 'assigns the results' do
          fake_search_form.stub(:submit).and_return(fake_result_set)
          get :show, {search_form: {query: 'apache'}}

          expect(assigns(:search_results)).to eql fake_result_set
        end
      end

      context 'when a json request' do
        it 'returns the json representation of the results' do
          fake_search_form.stub(:submit).and_return(fake_result_set)
          get :show, {search_form: {query: 'apache'}, format: :json}

          expect(response.body).to eql fake_result_set.to_json
        end
      end
    end
  end
end
