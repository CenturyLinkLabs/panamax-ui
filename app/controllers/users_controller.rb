class UsersController < ApplicationController
  respond_to :html

  def update
    user = User.find
    if user.update_attributes(params[:user])
      flash[:success] = I18n.t('users.update.success')
    else
      flash[:alert] = I18n.t('users.update.error')
    end
    redirect_to :back
  rescue => ex
    handle_exception(ex, redirect: :back)
  end
end
