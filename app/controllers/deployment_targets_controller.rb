class DeploymentTargetsController < ApplicationController
  respond_to :html

  def index
    @deployment_targets = DeploymentTarget.all
    @deployment_target = DeploymentTarget.new
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
end
