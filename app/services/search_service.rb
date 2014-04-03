class SearchService

  attr_accessor :connection

  def initialize(connection = SearchService.default_connection)
    @connection = connection
  end

  def search_for(query)
    response = connection.get '/search', {q: query}
    SearchResultSet.create_from_response(response.body)
  end

  def self.default_connection
    Faraday.new(url: PanamaxApi::URL)
  end
end

