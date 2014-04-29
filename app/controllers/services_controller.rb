class ServicesController < ApplicationController

  def show
    @app = applications_service.find_by_id(params[:application_id])
    @service = services_service.find_by_id(params[:application_id], params[:id])
  end

  private

  def applications_service
    @applications_service ||= ApplicationsService.new
  end

  def services_service
    @services_service ||= ServicesService.new
  end

end
