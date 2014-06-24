class AppsController < ApplicationController
  respond_to :html, except: [:journal]
  respond_to :json, only: [:journal, :destroy, :rebuild]

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
    @search_result_set = SearchResultSet.new
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
    resp = app.put(:rebuild)
    if resp.code == '204'
      flash[:success] = 'The application was successfully rebuilt.'
    else
      flash[:alert] = 'The application could not be rebuilt.'
    end
    respond_with app, location: request.referer || apps_path
  end

  private

  def retrieve_app
    App.find(params[:id])
  rescue ActiveResource::ResourceNotFound
    render status: :not_found
  end

  def journal_params
    params.permit(:cursor)
  end

end
