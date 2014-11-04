require 'spec_helper'

describe DeploymentTargetMetadataRefreshesController do
  describe '#create' do
    before do
      DeploymentTargetMetadataRefresh.stub(create: double)
      post :create, deployment_target_id: "19"
    end

    it 'creates a DeploymentTargetMetadataRefresh with the expected DeploymentTarget' do
      expect(DeploymentTargetMetadataRefresh).to(
        have_received(:create).
        with({ deployment_target_id: "19" })
      )
    end

    context 'HTML format' do
      it 'redirects to the deployments list' do
        expect(response).to redirect_to(deployment_targets_path)
      end
    end
  end
end
