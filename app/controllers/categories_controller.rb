class CategoriesController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token

  def update
    @category = retrieve_category
    @category.write_attributes(params[:category])
    @category.save
    respond_with @category
  end

  def create
    category = Category.new(name: params[:category][:name], app_id: params[:application_id])
    category.save

    respond_to do |format|
      format.html { redirect_to application_url(params[:application_id]) }
      format.json { render(json: category.to_json, status: status) }
    end
  end

  private

  def retrieve_category
    Category.find(params[:id], params: { app_id: params[:application_id] })
  end
end
