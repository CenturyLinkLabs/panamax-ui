class DeploymentTargetMetadataRefreshesController < ApplicationController
  respond_to :html, :json

  def create
    refresh = DeploymentTargetMetadataRefresh.create(
      deployment_target_id: params[:deployment_target_id]
    )

    flash[:success] = I18n.t('deployment_targets.metadata_refresh.success')
    respond_with(refresh, location: deployment_targets_path)
  end
end
