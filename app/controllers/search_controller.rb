class SearchController < ApplicationController
  respond_to :html, except: :load_tags
  respond_to :json

  def new
    @search_result_set = SearchResultSet.new
  end

  def show
    @search_result_set = SearchResultSet.find(params: params[:search_result_set])
    respond_with @search_result_set
  end

  def load_tags
    search_service = SearchService.new
    tags = search_service.tags_for(params[:repo], params[:local_image])
    respond_with tags
  end
end
