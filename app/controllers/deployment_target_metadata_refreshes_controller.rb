class DeploymentTargetMetadataRefreshesController < ApplicationController
  respond_to :html, :json

  def create
    use_flash = (request.format == :html)
    refresh = DeploymentTargetMetadataRefresh.create(
      deployment_target_id: params[:deployment_target_id]
    )

    flash[:success] = I18n.t('deployment_targets.metadata_refresh.success') if use_flash
    respond_with(refresh, location: deployment_targets_path)
  rescue ActiveResource::ServerError
    message = I18n.t('deployment_targets.metadata_refresh.failure')

    flash[:alert] = message if use_flash
    respond_with(
      { error: message },
      status: 409,
      location: deployment_targets_path
    )
  end
end
