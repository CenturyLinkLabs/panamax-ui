class CategoriesController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token

  def update
    @category = retrieve_category
    @category.write_attributes(params[:category])
    @category.save
    respond_with @category
  end

  private

  def retrieve_category
    Category.find(params[:id], params: {app_id: params[:application_id]})
  end
end