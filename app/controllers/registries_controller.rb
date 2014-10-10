class RegistriesController < ApplicationController
  def index
    @registries = Registry.all
  end
end
