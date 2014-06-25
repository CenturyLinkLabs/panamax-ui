class AppsController < ApplicationController
  respond_to :html, except: [:journal]
  respond_to :json, only: [:journal, :destroy]

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
    respond_with(app)
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
