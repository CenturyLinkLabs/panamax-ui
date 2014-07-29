class AppsController < ApplicationController
  respond_to :html, except: [:journal, :template]
  respond_to :json, except: [:create]
  protect_from_forgery except: :template

  def create
    if @app = App.create(params[:app])
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

  def template
    app = retrieve_app
    response = app.post(:template, params[:template_form])
    render json: response.body
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
  rescue ActiveResource::ServerError => ex
    handle_exception(ex, redirect: request.referer || apps_path)
  end

  private

  def retrieve_app
    App.find(params[:id])
  end

  def journal_params
    params.permit(:cursor)
  end
end
