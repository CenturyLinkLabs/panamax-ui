class RegistriesController < ApplicationController
  respond_to :html
  respond_to :json, only: [:update, :destroy]

  def index
    @registries = Registry.all
    @registry = Registry.new
  end

  def create
    @registry = Registry.create(params[:registry])

    if @registry.valid?
      flash[:success] = I18n.t('registries.create.success')
      redirect_to registries_url
    else
      @registries = Registry.all
      render :index
    end
  rescue => ex
    flash[:error] = I18n.t('registries.create.error')
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

  def update
    @registry = Registry.find(params[:id])
    @registry.update_attributes(params[:registry])
    respond_with(@registry)
  end
end
