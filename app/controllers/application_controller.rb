class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from StandardError, with: :handle_exception unless Rails.env.development?

  # EOFError is what is raised when AR can't communicate with the Panamax API
  rescue_from EOFError do |ex|
    handle_exception(ex, message: :panamax_api_connection_error)
  end unless Rails.env.development?

  def handle_exception(ex, message: nil, redirect: root_path)
    log_message = "\n#{ex.class} (#{ex.message}):\n"
    log_message << "  " << ex.backtrace.join("\n  ") << "\n\n"
    logger.error(log_message)

    message = message.nil? ? ex.message : t(message, default: message)

    if request.xhr?
      render json: { message: message }, status: :internal_server_error
    else
      redirect_to redirect, alert: message
    end
  end
end
