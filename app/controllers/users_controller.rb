class UsersController < ApplicationController
  respond_to :html

  def update
    user = User.find
    if user.update_attributes(params[:user])
      flash[:success] = 'Your GitHub token has been saved.'
    else
      flash[:alert] = "The GitHub token provided was not saved because it is invalid or too restrictive.
                      Validate the token is correct and make sure your token is scoped to 'repo' and 'user.'"
    end
    redirect_to :back
  rescue => ex
    handle_exception(ex, redirect: :back)
  end
end
