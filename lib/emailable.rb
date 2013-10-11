module Emailable
  module_function

  def default_url_options
    if Rails.env.development?
      { :host => 'localhost:3000'}
    else
      { :host => 'girlsguild.com'}
    end
  end
end