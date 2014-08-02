class ImagesController < ApplicationController
  def index
    @images = LocalImage.all
  end

  def destroy
    image = LocalImage.find(params[:id])
    if image.destroy
      flash[:notice] = 'image successfully removed'
    else
      flash[:error] = 'unable to remove image'
    end
    redirect_to images_url
  rescue => ex
    handle_exception(ex, redirect: images_url)
  end
end
