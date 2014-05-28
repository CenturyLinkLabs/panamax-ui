class ApplicationsController < ApplicationController
  respond_to :json, only: [:journal]

  def create
    @app = applications_service.create(params[:application])

    if @app.valid?
      flash[:success] = "The application was successfully created."
      redirect_to application_url(@app.to_param)
    else
      render :show
    end
  end

  def show
    @search_form = SearchForm.new
    render status: :not_found unless application.present?
  end

  def relations
    render partial: 'relationship_view', locals:  { app: application }, formats: [:html]
  end

  def destroy
    application, status = applications_service.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to applications_path }
      format.json { render(json: application.to_json, status: status) }
    end
  end

  def index
    @apps = applications_service.all
  end

  def documentation
    if application && application.documentation_to_html
      return render html: application.documentation_to_html.html_safe, layout:'documentation'
    else
      head status: :not_found
    end
  end

  def journal
    respond_with applications_service.journal(params[:id], journal_params)
  end

  private

  def application
    @app ||= applications_service.find_by_id(params[:id])
  end

  def applications_service
    @applications_service ||= ApplicationsService.new
  end

  def journal_params
    params.permit(:cursor)
  end
end
