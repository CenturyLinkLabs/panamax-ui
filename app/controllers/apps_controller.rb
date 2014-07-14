class AppsController < ApplicationController
  respond_to :html, except: [:journal]
  respond_to :json, except: [:create]

  after_action :remove_new_template, only: [:create_from_template]

  def create
    @template = Template.find_by_id(params[:app][:template_id])
    if @template.present? && @template.required_fields_missing?
      flash[:notice] = 'It looks like you are trying to run a template with some required fields. Please fill in the values below to continue.'
      redirect_to new_from_template_apps_path(template_id: @template.id)
    elsif @app = App.create(params[:app])
      flash[:success] = 'The application was successfully created.'
      redirect_to app_url(@app.to_param)
    else
      render :show
    end
  end

  def new_from_template
    @template = Template.find(params[:template_id])
    @form = TemplateCopyForm.new(original_template: @template)
  end

  def create_from_template
    original_template = Template.find(params[:template_copy_form].delete(:template_id))
    form = TemplateCopyForm.new(params[:template_copy_form].merge(original_template: original_template))
    @new_template = form.create_new_template
    if @new_template.present? && @new_template.required_fields_missing?
      flash[:notice] = 'It looks like you are trying to run a template with some required fields. Please fill in the values below to continue.'
      redirect_to new_from_template_apps_path(template_id: original_template.id)
    elsif @app = App.create(template_id: @new_template.id)
      flash[:success] = 'The application was successfully created.'
      redirect_to app_url(@app.to_param)
    else
      render :show
    end
  end

  def show
    @app = retrieve_app
    @app.categories.sort_by! { |cat| cat.position || @app.categories.length } if @app.categories
    @search_result_set = SearchResultSet.new
    rescue ActiveResource::ResourceNotFound
      render status: :not_found
  end

  def update
    @app = retrieve_app
    @app.write_attributes(params[:app])
    @app.save
    respond_with @app
  end

  def relations
    render partial: 'relationship_view', locals:  { app: retrieve_app }, formats: [:html]
  end

  def destroy
    app = retrieve_app
    app.destroy
    respond_with app, location: apps_path
  end

  def index
    @apps = App.all
  end

  def documentation
    app = retrieve_app
    if app && app.documentation_to_html
      return render html: app.documentation_to_html.html_safe, layout: 'documentation'
    else
      head status: :not_found
    end
  end

  def journal
    app = retrieve_app
    respond_with app.get(:journal, journal_params)
  end

  def rebuild
    app = retrieve_app
    if app.put(:rebuild)
      flash[:success] = 'The application was successfully rebuilt.'
    else
      flash[:alert] = 'The application could not be rebuilt.'
    end
    respond_with app, location: request.referer || apps_path
  end

  private

  def remove_new_template
    @new_template.destroy
  end

  def retrieve_app
    App.find(params[:id])
  end

  def journal_params
    params.permit(:cursor)
  end

end
