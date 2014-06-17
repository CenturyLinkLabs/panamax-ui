class SearchService

  attr_accessor :connection

  def initialize(connection=SearchService.default_connection)
    @connection = connection
  end

  def tags_for(repo, local=false)
    response = connection.get "/repositories/#{repo}/tags", local_image: local
    JSON.parse(response.body)
  end

  def self.default_connection
    Faraday.new(url: PanamaxApi::URL)
  end
end
