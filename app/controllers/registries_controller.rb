class RegistriesController < ApplicationController
  def index
    @registries = Registry.all
    @registry = Registry.new
  end

  def create
    @registry = Registry.create(params[:registry])
    flash[:success] = 'Your registry has been added successfully'
    redirect_to registries_url
  rescue => ex
    flash[:error] = 'Your registry could not be added'
    handle_exception(ex, redirect: registries_url)
  end
end
