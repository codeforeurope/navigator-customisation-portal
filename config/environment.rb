# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CityNavigatorCP::Application.initialize!

module System
	HTML_LANGUAGE = "en"
	BASE_URL = "http://themes.city-navigator.org"
end

module Permissions
  USER_DISABLED_PERMISSIONS = -1
  STANDARD_USER_PERMISSIONS = 0
  SUPER_ADMIN_PERMISSIONS = 67 
end
