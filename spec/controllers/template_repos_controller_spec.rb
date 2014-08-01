require 'spec_helper'

describe TemplateReposController do

  describe 'GET #index' do

    let(:template_repos) { [TemplateRepo.new] }

    before do
      TemplateRepo.stub(:all).and_return(template_repos)
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'retrieves all template repos' do
      get :index
      expect(assigns(:template_repos)).to eq template_repos
    end
  end
end
