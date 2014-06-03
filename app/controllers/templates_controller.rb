class TemplatesController < ApplicationController
  respond_to :html

  def new
    @user = User.find
  end
end
