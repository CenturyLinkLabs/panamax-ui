require 'spec_helper'

describe DashboardController do

  describe 'GET #index' do
    let(:limit) { 5 }
    let(:response) { double('response', header: { 'Total-Count' => '10' }) }
    let(:resource_response) { double('resource_response', response: response) }
    let(:resources) do
      {
        'Application' => { list: resource_response, count: 10, manage_path: apps_path, more_count: 5 },
        'Source' => { list: resource_response, count: 10, manage_path: template_repos_path, more_count: 5  },
        'Image' => { list: resource_response, count: 10, manage_path: images_path, more_count: 5  }
      }
    end

    it 'calls all_with_response on APP' do
      expect(App).to receive(:all_with_response).with(params: { limit: limit }).and_return(resource_response)
      get :index
    end

    it 'calls all_with_response on TemplateRepo' do
      expect(TemplateRepo).to receive(:all_with_response).with(params: { limit: limit }).and_return(resource_response)
      get :index
    end

    it 'calls all_with_response on LocalImage' do
      expect(LocalImage).to receive(:all_with_response).with(params: { limit: limit }).and_return(resource_response)
      get :index
    end

    it 'assigns values to the resources instance variable' do
      [App, TemplateRepo, LocalImage].each do |resource|
        resource.stub(:all_with_response).and_return(resource_response)
      end

      get :index
      expect(assigns(:resources)).to eq resources
    end

    it 'the map of resources contains expected keys' do
      get :index
      expect(assigns(:resources).keys).to match_array %w(Application Source Image)
    end
  end
end
