class ApplicationsController < ApplicationController
  def create
    applications_service.create(params[:application])
    render text: 'good job, you created an app'
  end

  private

  def applications_service
    @applications_service ||= ApplicationsService.new
  end
end
