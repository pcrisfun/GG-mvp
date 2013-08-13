class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include UsersHelper

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  after_filter :store_location

  def store_location
   # store last url - this is needed for post-login redirect to whatever the user last visited.
      if (request.fullpath != "/users/sign_in" && \
          request.fullpath != "/users/sign_up" && \
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath
      end
  end

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'https')
    if request.referer == sign_in_url
      session[:previous_url] || root_path
    else
      stored_location_for(resource) || request.referer || root_path
    end
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
