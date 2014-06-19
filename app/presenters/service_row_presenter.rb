class ServiceRowPresenter

  delegate :icon, :name, :status, to: :@service

  def initialize(service)
    @service = service
  end

  def service_url
    #todo: use url helper
    "/apps/#{@service.app.id}/services/#{@service.id}"
  end
end
