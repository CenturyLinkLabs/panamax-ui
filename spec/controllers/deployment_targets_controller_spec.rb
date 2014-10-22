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

  describe 'POST #create' do
    let(:fake_target) { [DeploymentTarget.new(name: 'test', endpoint_url: 'http://localhost:5000', auth_blob: 'xyzbcbc')] }
    let(:deployment_target_params) do
      { 'deployment_target' =>
          { 'name' => 'foo',
            'auth_blob' => 'zcvasdfasdf'
          }
      }
    end

    context 'when create is successful' do
      let(:valid_target) { double(:valid_target, valid?: true) }

      before do
        DeploymentTarget.stub(:create).with(
                             'name' => 'foo',
                             'auth_blob' => 'zcvasdfasdf'
                           ).and_return(valid_target)
        post :create, deployment_target_params
      end

      it 'creates the deployment_target' do
        expect(assigns(:deployment_target)).to eq valid_target
      end

      it 'shows a flash message for success' do
        expect(flash[:success]).to eql I18n.t('deployment_targets.create.success')
      end
    end

    context 'when the deployment_target is invalid' do
      let(:invalid_target) { double(:invalid_target, model_name: 'DeploymentTarget', valid?: false) }

      before do
        DeploymentTarget.stub(:create).and_return(invalid_target)
        post :create, deployment_target_params
      end

      it 'assigns the invalid deployment_target' do
        expect(assigns(:deployment_target)).to eq(invalid_target)
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end
  end
end
