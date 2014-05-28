class ServicesController < ApplicationController

  respond_to :json, only: [:journal]

  def show
    @app = applications_service.find_by_id(params[:application_id])
    @service = retrieve_service
  end

  def create
    service = Service.new(name: params[:name], from: "Image: #{params[:from]}", app_id: params[:application_id])
    unless params[:application][:category] == 'null'
      service.categories = [Category.find(params[:application][:category], params: { app_id: params[:application_id] })]
    end
    service.save

    respond_to do |format|
      format.html { redirect_to application_url(params[:application_id]) }
      format.json { render(json: service.to_json, status: status) }
    end
  end

  def build_category_param(application)
    [{:id => application[:category]}] unless application[:category] == 'null'
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
    if params[:service][:category]
      @service.categories << { id: params[:service][:category] }
    end
    @service.save

    respond_to do |format|
      format.html { redirect_to application_service_path(params[:application_id], @service.id) }
      format.json { render(json: @service.to_json, status: status) }
    end

  end

  def journal
    # We don't need to retrieve an actual service, just new one up with
    # the appropriate IDs.
    service = Service.new(id: params[:id], app_id: params[:application_id])
    respond_with service.get(:journal, cursor: params[:cursor])
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
