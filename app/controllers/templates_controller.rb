class TemplatesController < ApplicationController
  respond_to :html

  def new
    if app = App.find_by_id(params[:app_id])
      @user = User.find
      # don't show error if it is the first use
      if @user.has_invalid_github_creds?
        flash.now[:alert] = "Your token may be malformed, expired or is not scoped correctly.
Please <a href='https://github.com/settings/tokens/new?scope=repo,user:email' target='_blank'>
generate a Github access token</a> with the correct privileges. Be sure to select at least 'repo'
and 'user:email'."
      end
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
    @template_form = TemplateForm.new(params[:template_form])
    update_app(@template_form.app_id, @template_form.documentation)
    if @template_form.save
      flash[:success] = 'Template successfully created.'
      # add the repo to the source repos list for the user
      TemplateRepo.find_or_create_by_name(@template_form.repo)
      respond_with @template_form, location: apps_path
    else
      @user = User.find
      @template_form.user = @user
      @template_form.types = Type.all
      render :new
    end
  end

  def details
    @template = Template.find(params[:id])
    render layout: nil
  end

  private

  def update_app(app_id, documentation)
    app = App.find(app_id)
    app.write_attributes(documentation: documentation)
    app.save
  end
end
