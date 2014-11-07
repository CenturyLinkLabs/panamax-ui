require 'spec_helper'

describe DeploymentsController do
  describe 'GET #new' do
    let(:fake_deployment_form) { double(:fake_deployment_form) }
    let(:fake_deployment_target) { double(:fake_deployment_target) }
    let(:fake_template) { double(:fake_template) }

    before do
      Template.stub(:find).and_return(fake_template)
      DeploymentTarget.stub(:find).and_return(fake_deployment_target)
      DeploymentForm.stub(:new).with(
        template: fake_template,
        deployment_target_id: '7'
      ).and_return(fake_deployment_form)

      get :new, deployment_target_id: 7, template_id: '8'
    end

    it 'assigns the deployment_form object' do
      expect(assigns(:deployment_form)).to eq fake_deployment_form
    end

    it 'assigns the deployment_target object' do
      expect(assigns(:deployment_target)).to eq fake_deployment_target
    end

    it 'assigns the template object' do
      expect(assigns(:template)).to eq fake_template
    end

    it 'renders the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:fake_deployment_form) { double(:fake_deployment_form) }
    let(:create_params) do
      {
        deployment_target_id: '7',
        template_id: '8'
      }.stringify_keys
    end

    before do
      DeploymentForm.stub(:new).with(create_params).and_return(fake_deployment_form)
    end

    it 'calls save on the deployment form' do
      expect(fake_deployment_form).to receive(:save)
      post :create, deployment_form: create_params, deployment_target_id: 7
    end

    context 'when successful' do
      before do
        fake_deployment_form.stub(:save).and_return(true)
        post :create, deployment_form: create_params, deployment_target_id: 7
      end

      it 'redirects to the deployments list page' do
        expect(response).to redirect_to deployment_target_deployments_path(7)
      end

      it 'renders a success message' do
        expect(flash[:success]).to eq I18n.t('deployments.create.success')
      end
    end

    context 'when the save fails' do
      before do
        fake_deployment_form.stub(:save).and_return(false)
        post :create, deployment_form: create_params, deployment_target_id: 7
      end

      it 'redirects to the deployments list page' do
        expect(response).to redirect_to deployment_target_deployments_path(7)
      end

      it 'renders a success message' do
        expect(flash[:error]).to eq I18n.t('deployments.create.error')
      end
    end
  end

  describe 'GET #index' do
    let(:fake_target) { double(:fake_target) }
    let(:fake_deployments) { double(:fake_deployments) }

    before do
      DeploymentTarget.stub(:find).with('7').and_return(fake_target)
      Deployment.stub(:all).with(params: { deployment_target_id: '7' }).and_return(fake_deployments)
      get :index, deployment_target_id: 7
    end

    it 'renders the index view' do
      expect(response).to render_template :index
    end

    it 'assigns deployment_target' do
      expect(assigns(:deployment_target)).to eq fake_target
    end

    it 'assigns deployments' do
      expect(assigns(:deployments)).to eq fake_deployments
    end
  end

  describe 'DELETE #destroy' do
    let(:fake_deployment) { double(:fake_deployment, destroy: true) }

    before do
      Deployment.stub(:find).with('13', params: { deployment_target_id: '9' }).and_return(fake_deployment)
    end

    context 'html format' do
      before do
        delete :destroy, id: 13, deployment_target_id: 9
      end

      it 'deletes the target with the given id' do
        expect(fake_deployment).to have_received(:destroy)
      end

      it 'responds with a http 302 status code' do
        expect(response.status).to eq 302
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to deployment_target_deployments_path(9)
      end
    end

    context 'json request' do
      before do
        delete :destroy, id: 13, deployment_target_id: 9, format: :json
      end

      it 'deletes the target with the given id' do
        expect(fake_deployment).to have_received(:destroy)
      end

      it 'responds with a http 204 status code' do
        expect(response.status).to eq 204
      end

      it 'returns an empty response' do
        expect(response.body).to be_empty
      end
    end
  end
end
