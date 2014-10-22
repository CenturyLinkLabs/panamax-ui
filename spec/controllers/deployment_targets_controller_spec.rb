require 'spec_helper'

describe DeploymentTargetsController do
  describe 'GET #index' do
    let(:deployment_targets) { [double(:target1), double(:target2) ] }

    before do
      DeploymentTarget.stub(:all).and_return(deployment_targets)
    end

    it 'assigns all the deployment targets' do
      get :index
      expect(assigns(:deployment_targets)).to eq deployment_targets
    end

    it 'renders the the view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
