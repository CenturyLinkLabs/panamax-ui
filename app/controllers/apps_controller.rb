class AppsController < ApplicationController
  respond_to :html, except: [:journal, :template]
  respond_to :json, except: [:create]
  protect_from_forgery except: :template

  def create
    set_compose_yaml_file_param
    if @app = App.create(params[:app])
      flash[:success] = I18n.t('apps.create.success')
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
    @app = retrieve_app
    if @app && @app.documentation_to_html.present?
      render layout: 'plain'
    else
      head status: :not_found
    end
  end

  def template
    app = retrieve_app
    response = app.post(:template, params[:template_form])
    render json: response.body
  end

  def compose_yml
    app = retrieve_app
    response = Net::HTTP.get(URI("#{PanamaxApi::URL}/apps/#{app.id}/compose_yml.json"))
    render json: response
  end

  def compose_download
    app = retrieve_app
    compose_yml_for_app = Net::HTTP.get(URI("#{PanamaxApi::URL}/apps/#{app.id}/compose_yml.yaml"))
    send_data compose_yml_for_app, filename: 'docker-compose.yml', type: 'text/yaml'
  end

  def compose_export
    app = retrieve_app
    gist_response = Net::HTTP.post_form(URI("#{PanamaxApi::URL}/apps/#{app.id}/compose_gist.json"), {})
    gist_links = JSON.parse(gist_response.body)
    gist_uri = gist_links['links']['gist']['raw_url']
    redirect_to "https://lorry.io/#/?gist=#{gist_uri}"
  end

  def journal
    app = retrieve_app
    respond_with app.get(:journal, journal_params)
  end

  def rebuild
    app = retrieve_app
    if app.put(:rebuild)
      flash[:success] = I18n.t('apps.rebuild.success')
    else
      flash[:alert] = I18n.t('apps.rebuild.error')
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

  def set_compose_yaml_file_param
    params[:app][:compose_yaml_file] = fetch_compose_yaml_io if params[:app][:compose_yaml_uri].present?
  end

  def fetch_compose_yaml_io
    compose_yaml_uri = params[:app].delete(:compose_yaml_uri)
    yaml = Net::HTTP.get(URI(compose_yaml_uri))
    StringIO.new(yaml)
  end
end
