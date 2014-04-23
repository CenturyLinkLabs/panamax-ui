class ApplicationsController < ApplicationController
  def create
    @app = applications_service.create(params[:application])

    if @app.valid?
      redirect_to application_url(@app.to_param)
    else
      render :show
    end
  end

  def show
    @app = applications_service.find_by_id(params[:id])
    render status: :not_found unless @app.present?
  end

  def index

  end

  private

  def applications_service
    @applications_service ||= ApplicationsService.new
  end
end
