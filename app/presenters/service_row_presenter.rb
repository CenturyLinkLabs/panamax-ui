class ServiceRowPresenter

  attr_reader :service

  delegate :icon, :name, :status, to: :service

  def initialize(service)
    @service = service
  end

  def service_url
    "/applications/#{service.app.id}/services/#{service.id}"
  end
end
