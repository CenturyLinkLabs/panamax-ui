class ServicesController < ApplicationController

  respond_to :html, only: [:show, :destroy]
  respond_to :json

  def index
    @app = App.find(params[:app_id])
    respond_with @app.services
  end

  def show
    @app = App.find(params[:app_id])
    @service = retrieve_service
    respond_with @app, @service
  end

  def create
    service = Service.new(name: params[:name], from: params[:from], app_id: params[:app_id])
    unless params[:app][:category] == 'null'
      service.categories = [Category.find(params[:app][:category], params: { app_id: params[:app_id] })]
    end
    service.save

    respond_to do |format|
      format.html { redirect_to app_url(params[:app_id]) }
      format.json { render(json: service.to_json, status: status) }
    end
  end

  def build_category_param(app)
    [{ id: app[:category] }] unless app[:category] == 'null'
  end

  def destroy
    service = retrieve_service
    service.destroy
    respond_with service, location: app_path(params[:app_id])
  end

  def update
    @app = App.find(params[:app_id])
    @service = retrieve_service
    @service.write_attributes(params[:service])

    if params[:service][:category]
      @service.categories = [{ id: params[:service][:category], position: params[:service][:position] }]
    else
      @service.categories = []
    end

    if @service.save
      respond_to do |format|
        format.html { redirect_to app_service_path(params[:app_id], @service.id) }
        format.json { render(json: @service.to_json, status: status) }
      end
    else
      render :show
    end
  end

  def journal
    # We don't need to retrieve an actual service, just new one up with
    # the appropriate IDs.
    service = Service.new(id: params[:id], app_id: params[:app_id])
    respond_with service.get(:journal, cursor: params[:cursor])
  end

  private

  def retrieve_service
    Service.find(params[:id], params: { app_id: params[:app_id] })
  end
end
