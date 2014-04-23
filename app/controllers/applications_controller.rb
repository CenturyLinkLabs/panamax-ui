class ApplicationsController < ApplicationController
  def create
    applications_service.create(params[:application])
    render text: 'good job, you created an app'
  end

  def show

  end

  def index

  end

  private

  def applications_service
    @applications_service ||= ApplicationsService.new
  end
end
