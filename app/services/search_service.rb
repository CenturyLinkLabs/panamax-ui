class SearchService

  attr_accessor :connection

  def initialize(connection = SearchService.default_connection)
    @connection = connection
  end

  def search_for(query, type=nil)
    response = connection.get '/search', q: query, type: type
    SearchResultSet.build_from_response(response.body)
  end

  def tags_for(repo, local=false)
    response = connection.get "/repositories/#{repo}/tags", { local_image: local }
    JSON.parse(response.body)
  end

  def self.default_connection
    Faraday.new(url: PanamaxApi::URL)
  end
end

