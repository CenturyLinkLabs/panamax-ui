class ServicesController < ApplicationController

  def show
    @app = applications_service.find_by_id(params[:application_id])
    @service = services_service.find_by_id(params[:application_id], params[:id])
  end

  def destroy
    app = applications_service.find_by_id(params[:application_id])
    service, status = services_service.destroy(app.id, params[:id])
    respond_to do |format|
      format.html { redirect_to application_path app.id }
      format.json { render(json: service.to_json, status: status) }
    end

  end

  private

  def applications_service
    @applications_service ||= ApplicationsService.new
  end

  def services_service
    @services_service ||= ServicesService.new
  end

end
