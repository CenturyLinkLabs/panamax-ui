require 'spec_helper'

describe JobsController do
  describe 'GET #new' do

    let(:fake_template) { double(:fake_template) }
    let(:fake_job) { double(:fake_job) }

    before do
      allow(JobTemplate).to receive(:find).with('7').and_return(fake_template)
      allow(Job).to receive(:new_from_template).with(fake_template).and_return(fake_job)

      get :new, template_id: 7
    end

    it 'assigns the template' do
      expect(assigns(:template)).to eq(fake_template)
    end

    it 'assigns the job' do
      expect(assigns(:job)).to eq(fake_job)
    end

    it 'renders the view' do
      expect(response).to render_template(:new, layout: 'modal')
    end
  end

  describe 'POST #create' do
    let(:create_params) do
      {
        'template_id' => '8',
        'job_override_attributes' => {
          'environment_attributes' => {
            '0' => {
              'variable' => 'REMOTE_TARGET_NAME',
              'value' => ''
            },
            '1' => {
              'variable' => 'CLIENT_ID',
              'value' => ''
            }
          }
        }
      }
    end

    context 'when creation succeeds' do
      before do
        allow(Job).to receive(:nested_create).with(create_params).and_return(true)
        post :create, job: create_params
      end

      it 'creates the job' do
        expect(Job).to have_received(:nested_create).with(create_params)
      end

      it 'redirects to the deployment_targets list page' do
        expect(response).to redirect_to deployment_targets_url
      end

      it 'displays the flash notice' do
        expect(flash[:notice]).to eql I18n.t('jobs.create.success')
      end
    end

    context 'when creation fails' do
      before do
        allow(Job).to receive(:nested_create).with(create_params).and_return(false)
        post :create, job: create_params
      end

      it 'displays the flash error' do
        expect(flash[:error]).to eql I18n.t('jobs.create.failure')
      end
    end
  end
end
