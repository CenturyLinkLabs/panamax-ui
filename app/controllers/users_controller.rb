class UsersController < ApplicationController
  respond_to :html

  def update
    user = User.find
    user.update_attributes(params[:user])
    redirect_to :back
  end
end
