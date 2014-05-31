class ServiceRowPresenter
  def initialize(service)
    @service = service
  end

  delegate :icon, :name, :status, to: :service

  def service_url
    "/applications/#{service.app.id}/services/#{service.id}"
  end

  private

  attr_reader :service
end
