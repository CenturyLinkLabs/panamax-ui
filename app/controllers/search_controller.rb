class SearchController < ApplicationController
  def new
    @search = Search.new
  end
end
