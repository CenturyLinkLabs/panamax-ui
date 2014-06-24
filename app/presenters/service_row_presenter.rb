class ServiceRowPresenter

  delegate :id, :icon, :name, :status, to: :@service

  def initialize(service)
    @service = service
  end

  def service_url
    Rails.application.routes.url_helpers.app_service_path(@service.app.id, @service.id)
  end
end
