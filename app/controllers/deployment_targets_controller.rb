class DeploymentTargetsController < ApplicationController
  respond_to :html

  def index
    @deployment_targets = DeploymentTarget.all
  end
end
