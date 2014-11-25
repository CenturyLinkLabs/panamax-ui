class DeploymentTargetMetadataRefreshesController < ApplicationController
  respond_to :html

  def create
    deployment_target_id = params[:deployment_target_id]

    DeploymentTargetMetadataRefresh.create(
      deployment_target_id: deployment_target_id
    )
    flash[:success] = I18n.
      t('deployment_targets.metadata_refresh.success')
    redirect_to deployment_targets_path
  end
end
