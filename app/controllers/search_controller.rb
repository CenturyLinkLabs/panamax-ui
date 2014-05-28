class SearchController < ApplicationController
  respond_to :html, except: :load_tags
  respond_to :json

  def new
    @search_form = SearchForm.new
  end

  def show
    @search_form = SearchForm.new
    @search_results = @search_form.submit(params[:search_form])
    respond_with @search_results
  end

  def load_tags
    search_service = SearchService.new
    tags = search_service.tags_for(params[:repo], params[:local])
    respond_with tags
  end

end
