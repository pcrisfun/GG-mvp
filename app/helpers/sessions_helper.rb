module SessionsHelper

  def store_location
    session[:return_to] = request.fullpath
  end

  def return_store_location_or(default)
    session[:reject_to] || default
  end

  def redirect_back_or(default, options = {})
    redirect_to session[:return_to] || default, notice: options[:notice]
    clear_stored_location
  end

  def clear_stored_location
   session[:return_to] = nil
  end

end