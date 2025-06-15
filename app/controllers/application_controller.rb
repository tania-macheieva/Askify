class ApplicationController < ActionController::Base
  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from StandardError, with: :render_500

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def render_404(exception = nil)
    logger.error("404 Not Found: #{exception.message}") if exception
    render template: "public/404", status: :not_found
  end

  def render_500(exception = nil)
    logger.error("500 Internal Server Error: #{exception.message}") if exception
    render template: "public/500", status: :internal_server_error
  end
end
