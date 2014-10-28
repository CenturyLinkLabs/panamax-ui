class DeploymentSettingsController < ApplicationController

  def index
    @template = Template.first()
  end

  def show
    @template = Template.first()
  end
end
