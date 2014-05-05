class ApplicationsService

  attr_accessor :connection

  def initialize(connection = ApplicationsService.default_connection)
    @connection = connection
  end

  def find_by_id(id)
    response = connection.get "/apps/#{id}"
    App.build_from_response(response.body) unless response.status == 404
  end

  def create(params)
    response = connection.post do |req|
      req.url '/apps'
      req.headers['Content-Type'] = 'application/json'
      req.body = params.to_json
    end
    App.build_from_response(response.body)
  end

  def self.default_connection
    Faraday.new(url: PanamaxApi::URL)
  end
end

