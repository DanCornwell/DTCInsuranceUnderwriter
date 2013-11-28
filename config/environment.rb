# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load the app's custom environment variables here, before environments/*.rb
app_env_email_password = File.join(Rails.root, 'config', 'initializers', 'app_env_email_password.rb')
load(app_env_email_password) if File.exists?(app_env_email_password)

# Initialize the Rails application.
DTCInsuranceUnderwriter::Application.initialize!