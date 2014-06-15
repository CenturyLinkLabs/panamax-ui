class MetricsController < ApplicationController
  respond_to :json

  def index
    respond_with metrics_service.all
  end

  def overall
    respond_with metrics_service.overall
  end

  private

  def metrics_service
    @metrics_service ||= MetricService.new
  end
end
