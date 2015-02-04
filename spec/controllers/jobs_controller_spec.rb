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

  describe 'GET #show' do
    let(:fake_job) { double(:fake_job) }

    before do
      allow(fake_job).to receive(:with_template!).and_return(fake_job)
      allow(fake_job).to receive(:with_step_status!).and_return(job: 'bla')
      allow(Job).to receive(:find).with('7').and_return(fake_job)
      get :show, key: 7, format: :json
    end

    it 'returns a json representation of the job' do
      expect(response.body).to eq({ job: 'bla' }.to_json)
    end
  end

  describe 'GET #log' do
    let(:fake_job) { double(:fake_job) }

    before do
      allow(Job).to receive(:new).with(id: '7').and_return(fake_job)
      allow(fake_job).to receive(:get).with(:log, index: 13).and_return(lines: [])
      get :log, key: 7, index: 13, format: :json
    end

    it 'returns a json representation of the job log' do
      expect(response.body).to eq({ lines: [] }.to_json)
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
    end

    context 'when creation fails' do
      before do
        allow(Job).to receive(:nested_create).with(create_params).and_return(false)
        post :create, job: create_params
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the job with the given key' do
      expect(Job).to receive(:delete).with('xyz')
      delete :destroy, key: 'xyz', format: :json
    end
  end
end
