class ErrorsController < ApplicationController
  def not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end

  def internal_server_error
    render file: Rails.public_path.join("500.html"), status: :internal_server_error, layout: false
  end
end
