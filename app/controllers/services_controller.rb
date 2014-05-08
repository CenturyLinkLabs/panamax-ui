class ServicesController < ApplicationController

  def show
    @app = applications_service.find_by_id(params[:application_id])
    @service = retrieve_service
  end

  def destroy
    service, status = services_service.destroy(params[:application_id], params[:id])
    respond_to do |format|
      format.html { redirect_to application_path params[:application_id] }
      format.json { render(json: service.to_json, status: status) }
    end
  end

  def update
    @service = retrieve_service
    @service.write_attributes(params[:service])
    @service.save
    redirect_to application_service_path(params[:application_id], @service.id)
  end

  private

  def retrieve_service
    Service.find(params[:id], params: {app_id: params[:application_id]})
  end

  def applications_service
    @applications_service ||= ApplicationsService.new
  end

  def services_service
    @services_service ||= ServicesService.new
  end

end
