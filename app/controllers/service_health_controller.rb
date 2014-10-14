class ServiceHealthController < ApplicationController
  respond_to :json

  def show
    health = ServiceHealth.find(params[:id])
    respond_with health.overall
  end
end
