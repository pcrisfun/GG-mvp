class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include UsersHelper

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private
  def render_error(status, exception)
    respond_to do |format|
      formatted_exception = "== #{exception.message} \n #{exception.backtrace}"
      puts formatted_exception
      logger.error(formatted_exception)
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end 
  end
end
