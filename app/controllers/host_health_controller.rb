class HostHealthController < ApplicationController
  respond_to :json

  def index
    health = HostHealth.find
    respond_with health.overall
  end
end
