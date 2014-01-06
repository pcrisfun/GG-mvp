Airbrake.configure do |config|
  config.api_key = 'AIRBRAKE_API_KEY'
  config.rescue_rake_exceptions = true
  # config.development_environments = []
  # reports on all environments
end
