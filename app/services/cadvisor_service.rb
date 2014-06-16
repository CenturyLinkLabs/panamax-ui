class CadvisorService

  attr_accessor :connection

  def initialize(connection=CadvisorService.default_connection)
    @connection = connection
  end

  def all
    response = connection.get '/api/v1.0/containers/'
    JSON.parse(response.body)
  end

  def self.default_connection
    Faraday.new(url: "#{ENV['CADVISOR_PORT']}")
  end
end
