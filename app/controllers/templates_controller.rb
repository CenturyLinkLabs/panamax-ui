class TemplatesController < ApplicationController
  respond_to :html

  def new
    if app = App.find_by_id(params[:app_id])
      @user = User.find
      @template_form = TemplateForm.new(
        types: Type.all,
        user: @user,
        app: app
      )
    else
      redirect_to apps_path, alert: 'could not find application'
    end
  end

  def create
    @user = User.find
    @template_form = TemplateForm.new(params[:template_form])
    if @template_form.save
      flash[:success] = 'Template successfully created.'
    end
    respond_with @template_form, location: apps_path
  end
end
