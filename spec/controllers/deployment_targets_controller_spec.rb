require 'spec_helper'

describe DeploymentTargetsController do
  let(:deployment_targets) { [double(:target1), double(:target2)] }
  let(:job_templates) { [double(:template1), double(:template2)] }
  let(:job) { double(:job) }
  let(:jobs) { [job] }

  before do
    allow(job).to receive(:with_step_status!).and_return(job)
  end

  describe 'GET #index' do
    before do
      allow(DeploymentTarget).to receive(:all).and_return(deployment_targets)
      allow(JobTemplate).to receive(:all).and_return(job_templates)
      allow(Job).to receive(:all).and_return(jobs)
      get :index
    end

    it 'assigns all the deployment targets' do
      expect(assigns(:deployment_targets)).to eq deployment_targets
    end

    it 'assigns all the jobs' do
      expect(assigns(:jobs)).to eq jobs
    end

    it 'assigns the job templates' do
      expect(assigns(:job_templates)).to eq job_templates
    end

    it 'renders the view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #select' do
    let(:deployment_targets) { [double(:target1), double(:target2) ] }
    let(:fake_resource) { { id: '7', type: 'Template' } }

    before do
      allow(DeploymentTarget).to receive(:all).and_return(deployment_targets)
    end

    context 'with a template id passed in ' do
      before do
        get :select, resource_id: 7, resource_type: 'Template'
      end

      it 'assigns all the deployment targets' do
        expect(assigns(:deployment_targets)).to eq deployment_targets
      end

      it 'renders the view in the plain layout' do
        expect(response).to render_template :select, layout: 'plain'
      end

      it 'assigns the resource' do
        expect(assigns(:resource)).to eq fake_resource
      end
    end
  end

  describe 'POST #create' do
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
        allow(DeploymentTarget).to receive(:create).with(
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
        allow(DeploymentTarget).to receive(:create).and_return(invalid_target)
        allow(DeploymentTarget).to receive(:all).and_return(deployment_targets)
        allow(JobTemplate).to receive(:all).and_return(job_templates)
        allow(Job).to receive(:all).and_return(jobs)
        post :create, deployment_target_params
      end

      it 'assigns the invalid deployment_target' do
        expect(assigns(:deployment_target)).to eq(invalid_target)
      end

      it 'assigns all the deployment targets' do
        expect(assigns(:deployment_targets)).to eq deployment_targets
      end

      it 'assigns all the jobs' do
        expect(assigns(:jobs)).to eq jobs
      end

      it 'assigns the job templates' do
        expect(assigns(:job_templates)).to eq job_templates
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:fake_target) { double(:fake_target, destroy: true) }

    before do
      allow(DeploymentTarget).to receive(:find).with('13').and_return(fake_target)
    end

    context 'html format' do
      before do
        delete :destroy, id: 13
      end

      it 'deletes the target with the given id' do
        expect(fake_target).to have_received(:destroy)
      end

      it 'responds with a http 302 status code' do
        expect(response.status).to eq 302
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to deployment_targets_path
      end
    end

    context 'json request' do
      before do
        delete :destroy, id: 13, format: :json
      end

      it 'deletes the target with the given id' do
        expect(fake_target).to have_received(:destroy)
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
