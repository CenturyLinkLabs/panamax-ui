class ApplicationsService

  attr_accessor :connection

  def initialize(connection = ApplicationsService.default_connection)
    @connection = connection
  end

  def create(params)
    connection.post do |req|
      req.url '/apps'
      req.headers['Content-Type'] = 'application/json'
      req.body = params.to_json
    end
  end

  def self.default_connection
    Faraday.new(url: PanamaxApi::URL)
  end
end

