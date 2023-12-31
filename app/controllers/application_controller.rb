class ApplicationController < ActionController::Base
  include ApplicationHelper
  # This is rails default session manager. We don't need it as we are implementing our own using jwt
  skip_before_action :verify_authenticity_token
  before_action :authorized
end
