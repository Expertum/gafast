# Load the rails application
require File.expand_path('../application', __FILE__)

GFS_VERSION = "0.0.1"

EMAIL = "gfs@expertum-ave.com"
EMAIL_FROM = '"Gration Farm System" <'+EMAIL+'>' unless defined? EMAIL_FROM

# Initialize the rails application
Gafast::Application.initialize!
