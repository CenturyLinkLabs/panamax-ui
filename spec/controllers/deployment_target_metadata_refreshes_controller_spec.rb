require 'spec_helper'

describe DeploymentTargetMetadataRefreshesController do
  describe '#create' do
    subject { response }
    let(:format) { :html }
    before do
      DeploymentTargetMetadataRefresh.stub(:create).and_call_original
      post :create, deployment_target_id: '19', format: format
    end

    it 'creates a DeploymentTargetMetadataRefresh with the expected DeploymentTarget' do
      expect(DeploymentTargetMetadataRefresh).to(
        have_received(:create).
        with({ deployment_target_id: '19' })
      )
    end

    context 'HTML format' do
      it { should redirect_to(deployment_targets_path) }
    end

    context 'JSON format' do
      let(:format) { :json }

      its(:status) { should eq(201) }

      describe 'the JSON response' do
        subject(:hash) { JSON.parse(response.body) }
        its(:keys) { should include('agent_version', 'adapter_type') }
      end
    end
  end
end
