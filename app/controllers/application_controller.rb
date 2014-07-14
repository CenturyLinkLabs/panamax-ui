class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from EOFError, with: :handle_api_unavailable

  def handle_api_unavailable(ex)
    logger.error "#{ex.class} - #{ex.message}"
    logger.error "\t#{ex.backtrace.join("\n\t")}"

    if request.xhr?
      head :internal_server_error
    else
      redirect_to root_path, alert: 'Panamax API is not responding'
    end
  end
end
