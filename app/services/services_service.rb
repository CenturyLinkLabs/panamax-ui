class ServicesService

  attr_accessor :connection

  def initialize(connection = ApplicationsService.default_connection)
    @connection = connection
  end

  def find_by_id(app_id, service_id)
    response = connection.get "/apps/#{app_id}/services/#{service_id}"
    Service.create_from_response(response.body) unless response.status == 404
  end

  def self.default_connection
    Faraday.new(url: PanamaxApi::URL)
  end
end
