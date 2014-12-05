class ImagesController < ApplicationController
  def index
    @images = LocalImage.all
  end

  def destroy
    image = LocalImage.find(params[:id])
    if image.destroy
      flash[:success] = I18n.t('images.destroy.success')
    else
      flash[:error] = I18n.t('images.destroy.error')
    end
    redirect_to images_url
  rescue => ex
    handle_exception(ex, redirect: images_url)
  end

  def destroy_multiple
    if params[:delete]
      result = LocalImage.batch_destroy(params[:delete].keys)
      build_message(result)
    end
    redirect_to images_url
  rescue => ex
    handle_exception(ex, redirect: images_url)
  end

  private

  def build_message(result)
    count = result[:count]
    failed = result[:failed]
    unless count == 0
      flash[:notice] = "#{count} #{'image'.pluralize(count)} successfully removed"
    end
    unless failed.empty?
      flash[:alert] = failed.inject('') { | memo, message| memo << "<p>#{message}</p>" }
    end
  end
end
