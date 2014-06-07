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
   if (!request.fullpath.match("/users") &&
    !request.xhr?) # don't store ajax calls
    session[:previous_url] = request.fullpath
   end
  end

  #def after_sign_in_path_for(resource)
  #  if Rails.env.production?
  #    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'https')
  #  else
  #    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
  #  end
  #  if request.referer == sign_in_url
  #    session["user_return_to"] || root_path
  #  else
  #    stored_location_for(resource) || request.referer || root_path
  #  end
  #end

  # If your model is called User
  def after_sign_in_path_for(resource)
    session["user_return_to"] || root_path
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
