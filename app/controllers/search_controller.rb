class SearchController < ApplicationController
  respond_to :html, :json

  def new
    @search_form = SearchForm.new
  end

  def show
    @search_form = SearchForm.new
    @search_results = @search_form.submit(params[:search_form])
    respond_with @search_results
  end
end
