class UsersController < ApplicationController
  respond_to :html

  def update
    user = User.find
    user.update_attributes(params[:user])
    redirect_to :back
  rescue => ex
    handle_exception(ex, redirect: :back)
  end
end
