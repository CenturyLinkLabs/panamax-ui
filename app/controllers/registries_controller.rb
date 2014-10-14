class RegistriesController < ApplicationController
  respond_to :json, only: :destroy

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

  def destroy
    registry = Registry.find(params[:id])
    if registry.destroy
      flash[:success] = I18n.t('registries.destroy.success')
      respond_with registry
    end
  rescue => ex
    flash[:error] = I18n.t('registries.destroy.error')
    handle_exception(ex, redirect: registries_path)
  end
end
