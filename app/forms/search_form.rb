require 'active_model'

class SearchForm
  include ActiveModel::Model

  attr_accessor :query, :search_service

  def initialize(search_service = SearchService.new)
    @search_service = search_service
  end

  def submit(params)
    search_service.search_for(params[:query])
  end
end
