class SearchController < ApplicationController
  respond_to :html, except: :load_tags
  respond_to :json

  def new
    @search_result_set = SearchResultSet.new
    @keywords_sorted_by_term = Keyword.all_sorted_by(:keyword)
    @keywords_sorted_by_count = Keyword.all_sorted_by(:count).reverse
  end

  def show
    @search_result_set = SearchResultSet.find(params: params[:search_result_set])
    respond_with @search_result_set
  end

  def load_tags
    repository = Repository.find(
      params[:repo], params: { registry_id: params[:registry_id], local: params[:local_image] })

    respond_with repository.image_tags
  end
end
