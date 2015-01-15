class DeploymentTargetsController < ApplicationController
  respond_to :html
  respond_to :json, only: [:destroy]

  def index
    @deployment_targets = DeploymentTarget.all
    @deployment_target = DeploymentTarget.new
    @job_templates = JobTemplate.all
  end

  def select
    @resource = { type: params[:resource_type], id: params[:resource_id] }
    @deployment_targets = DeploymentTarget.all
    render layout: 'plain'
  end

  def create
    @deployment_target = DeploymentTarget.create(params[:deployment_target])
    if @deployment_target.valid?
      flash[:success] = I18n.t('deployment_targets.create.success')
      redirect_to deployment_targets_path
    else
      @deployment_targets = DeploymentTarget.all
      render :index
    end
  end

  def destroy
    target = DeploymentTarget.find(params[:id])
    respond_with(target.destroy, location: deployment_targets_path)
  end

end
