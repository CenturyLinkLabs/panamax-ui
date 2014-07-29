class ImagesController < ApplicationController
  def index
    @images = LocalImage.all
  end
end
